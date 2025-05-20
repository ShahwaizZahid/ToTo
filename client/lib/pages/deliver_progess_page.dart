import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DeliveryProgessPage extends StatefulWidget {
  const DeliveryProgessPage({super.key});

  @override
  State<DeliveryProgessPage> createState() => _DeliveryProgessPageState();
}

class _DeliveryProgessPageState extends State<DeliveryProgessPage> {
  List userCart = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCartItems().then((items) {
      setState(() {
        userCart = items;
      });

      // ✅ Print userCart after it has been updated
      print("📦 User Cart after setting state:");
      print(userCart);
    });
  }


  Future<List<dynamic>> fetchCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('UserId');
    if (userId == null) {
      print("user not");
      return [];
    }

    try {
      setState(() {
        isLoading= true;
      });
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5001/get_cart_items?userId=$userId'),
      );

      if (response.statusCode == 200) {

        final List<dynamic> cartItems = jsonDecode(response.body); // ✅ directly parse as List
        print("ad");
        return cartItems;
      } else {
        print('Failed to load cart items. Status code: ${response.statusCode}');
      }
      setState(() {
        isLoading= false;
      });
    } catch (e) {
      setState(() {
        isLoading= false;
      });
      print('Error loading cart items: $e');
    }

    return [];
  }


  String generateReceipt() {
    final receipt = StringBuffer();

    int totalItems = 0;
    double totalPrice = 0;

    for (final cartItem in userCart) {
      int quantity = (cartItem['count'] ?? 0).toInt();

      final name = cartItem['name'] ?? 'Unknown';

      final price = (cartItem['price'] is int)
          ? (cartItem['price'] as int).toDouble()
          : (cartItem['price'] ?? 0.0);

      final addons = cartItem['addons'] as List<dynamic>? ?? [];

      // Calculate total add-ons price
      double addonsTotalPrice = 0;
      for (final addon in addons) {
        double addonPrice = 0;
        if (addon is Map && addon.containsKey('price')) {
          addonPrice = (addon['price'] is int)
              ? (addon['price'] as int).toDouble()
              : (addon['price'] ?? 0.0);
        }
        addonsTotalPrice += addonPrice;
      }

      num itemBaseTotal = quantity * price;

      double itemAddonsTotal = quantity * addonsTotalPrice; // add-ons price per quantity

      double itemTotalPrice = itemBaseTotal + itemAddonsTotal;

      totalItems += quantity;
      totalPrice += itemTotalPrice;

      receipt.writeln("$quantity x $name - ${_formatPrice(price)} each");

      if (addons.isNotEmpty) {
        receipt.writeln("     Add-ons:");
        for (final addon in addons) {
          final addonName = addon['name'] ?? 'Addon';
          final addonPrice = (addon['price'] is int)
              ? (addon['price'] as int).toDouble()
              : (addon['price'] ?? 0.0);
          receipt.writeln("       - $addonName: ${_formatPrice(addonPrice)}");
        }
      }

      receipt.writeln("     Item total: ${_formatPrice(itemTotalPrice)}");
      receipt.writeln();
    }

    // Calculate delivery time: now + 30 minutes
    final now = DateTime.now();
    final deliveryTime = now.add(Duration(minutes: 30));
    // Format delivery time nicely, e.g., "3:45 PM"
    final formattedDeliveryTime = DateFormat.jm().format(deliveryTime);

    receipt.writeln("----------------------------------------------------------------");
    receipt.writeln("Total items: $totalItems");
    receipt.writeln("Total Price: ${_formatPrice(totalPrice)}");
    receipt.writeln("Estimated Delivery Time: $formattedDeliveryTime");
    receipt.writeln("----------------------------------------------------------------");

    return receipt.toString();
  }
  String _formatPrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }


  String _formatAddons(List<dynamic> addons) {
    // assuming each addon is a map with a 'name' key
    return addons.map((a) => a['name']).join(', ');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery in progess'),
        backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all( color: Theme.of(context).colorScheme.background, width: 2), // Border color and width
            borderRadius: BorderRadius.circular(8), // Optional: rounded corners
            color: Theme.of(context).colorScheme.background, // Optional: background color inside the border
          ),
          padding: EdgeInsets.symmetric(vertical: 0,horizontal: 5),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - kToolbarHeight - 100, // approx space minus app bar & bottom nav bar
            child: Center(
              child: Text(
                generateReceipt(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontSize: 16),
              ),
            ),
          ),
        ),
      ),


    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40))),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          // Profile Pic of  Deliver
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                shape: BoxShape.circle),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.person,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Farooq",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
              Text(
                "Driver",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              )
            ],
          ),
          Spacer(),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    shape: BoxShape.circle),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.message),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    shape: BoxShape.circle),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.call),
                  color: Colors.green,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
