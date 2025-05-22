import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  List<TextEditingController> addonNameControllers = [TextEditingController()];
  List<TextEditingController> addonPriceControllers = [TextEditingController()];
  File? selectedImage;

  final List<String> categories = ['burgers', 'sides', 'drinks', 'desserts','salads'];
  String? selectedCategory;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  }




  void addAddon() {
    setState(() {
      addonNameControllers.add(TextEditingController());
      addonPriceControllers.add(TextEditingController());
    });
  }

  void removeAddon(int index) {
    if (addonNameControllers.length > 1) {
      setState(() {
        addonNameControllers.removeAt(index);
        addonPriceControllers.removeAt(index);
      });
    }
  }



  Future<void> addFood() async {
    final name = nameController.text.trim();
    final description = descController.text.trim();
    final category = selectedCategory;
    final price = double.tryParse(priceController.text.trim()) ?? 0;

    final List<Map<String, dynamic>> validAddons = [];

    for (int i = 0; i < addonNameControllers.length; i++) {
      final addonName = addonNameControllers[i].text.trim();
      final addonPrice = double.tryParse(addonPriceControllers[i].text.trim());
      if (addonName.isNotEmpty && addonPrice != null) {
        validAddons.add({'name': addonName, 'price': addonPrice});
      }
    }

    if (name.isEmpty ||
        description.isEmpty ||
        category == null ||
        price <= 0 ||
        selectedImage == null ||
        validAddons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly')),
      );
      return;
    }
    // Convert image to base64
    final bytes = await selectedImage!.readAsBytes();
    final base64Image = base64Encode(bytes);
    // Prepare request payload
    final Map<String, dynamic> body = {
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'image': base64Image,
      'addons': validAddons,
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5001/api/admin/food/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Food added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${jsonDecode(response.body)['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect: $e')),
      );
    }
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text,
        List<TextInputFormatter>? formatters,
        int? maxLines,
        int? maxLength}) {
    final borderColor = Theme.of(context).colorScheme.inversePrimary; // 👈 Change this to your desired color
    final focusedBorderColor = Theme.of(context).colorScheme.inversePrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: type,
        inputFormatters: formatters,
        maxLines: maxLines,
        maxLength: maxLength,
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: focusedBorderColor, width: 2),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.inversePrimary),
        title: Text('Add New Food', style: TextStyle(color: color.inversePrimary),),
        centerTitle: true,
        backgroundColor: color.background,
      ),
      backgroundColor: color.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: color.background,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildTextField('Food Name', nameController),
                    buildTextField('Description', descController, maxLines: 3, maxLength: 70),
                    buildTextField(
                      'Price',
                      priceController,
                      type: TextInputType.numberWithOptions(decimal: true),
                      formatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(

                      value: selectedCategory,
                      items: categories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      dropdownColor: Theme.of(context).colorScheme.background, // 👈 Background color of dropdown
                      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                      onChanged: (value) => setState(() => selectedCategory = value),
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: color.inversePrimary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: color.inversePrimary, width: 2),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Choose Image'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.inversePrimary,
                        foregroundColor: color.background,
                      ),
                    ),
                    if (selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(selectedImage!, height: 150),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text('Addons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color.primary)),

            ...List.generate(addonNameControllers.length, (index) {
              return Card(
                color: Theme.of(context).colorScheme.background,
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(
                  color: color.inversePrimary, // 👈 Border color
                  width: 1.5,               // 👈 Border width
                ),),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(child: buildTextField('Addon Name', addonNameControllers[index])),
                      const SizedBox(width: 10),
                      Expanded(
                        child: buildTextField(
                          'Price',
                          addonPriceControllers[index],
                          type: TextInputType.numberWithOptions(decimal: true),
                          formatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => removeAddon(index),
                      ),
                    ],
                  ),
                ),
              );
            }),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: addAddon,
                icon: const Icon(Icons.add),
                label: const Text("Add Addon"),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: addFood,
                icon:  Icon(Icons.check_circle_outline, color: color.inversePrimary,),
                label:  Text('Add Food', style: TextStyle(fontSize: 16, color: color.inversePrimary)),
                style: ElevatedButton.styleFrom(

                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: color.background,
                  foregroundColor: color.onPrimary,
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: color.inversePrimary, // 👈 Border color
                        width: 1.5,               // 👈 Border width
                      )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
