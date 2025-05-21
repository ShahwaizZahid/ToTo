import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

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

  void addFood() {
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

    print('--- FOOD ITEM ---');
    print('Name: $name');
    print('Description: $description');
    print('Category: $category');
    print('Price: $price');
    print('Image Path: ${selectedImage!.path}');
    print('Addons:');
    print(validAddons);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Food added successfully (check terminal)')),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text,
        List<TextInputFormatter>? formatters,
        int? maxLines,
        int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: type,
        inputFormatters: formatters,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Food'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField('Food Name', nameController),
            buildTextField(
              'Description',
              descController,
              maxLines: 3,
              maxLength: 70,
            ),

            buildTextField(
              'Price',
              priceController,
              type: TextInputType.numberWithOptions(decimal: true),
              formatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) => setState(() => selectedCategory = value),
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Choose Image'),
                ),
                const SizedBox(width: 10),
                if (selectedImage != null)
                  Expanded(
                    child: Text(
                      selectedImage!.path,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Addons',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(addonNameControllers.length, (index) {
              return Row(
                children: [
                  Expanded(
                    child: buildTextField('Addon Name', addonNameControllers[index]),
                  ),
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
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addFood,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Add Food', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
