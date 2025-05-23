import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../components/my_receipt.dart';
import '../models/restaurant.dart';

class DeliveryProgessPage extends StatefulWidget {
  const DeliveryProgessPage({super.key});

  @override
  State<DeliveryProgessPage> createState() => _DeliveryProgessPageState();
}

class _DeliveryProgessPageState extends State<DeliveryProgessPage> {
  List userCart = [];
  bool isLoading = true;
  bool _orderPlaced = false;

  @override
  void initState() {
    super.initState();
    fetchCartItems().then((items) {
      setState(() {
        userCart = items;
        isLoading = false;
      });

      // Place order only once
      if (!_orderPlaced && userCart.isNotEmpty) {
        placeOrderToBackend(userCart);
      }
    });
  }

  Future<List<dynamic>> fetchCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('UserId');
    if (userId == null) return [];

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5001/get_cart_items?userId=$userId'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to load cart items. Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading cart items: $e');
    }

    return [];
  }

  Future<void> placeOrderToBackend(List cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('UserId');

    if (userId == null || cartItems.isEmpty) return;

    int totalItems = 0;
    double totalPrice = 0;

    for (final cartItem in cartItems) {
      int quantity = (cartItem['count'] ?? 0).toInt();
      double price = (cartItem['price'] is int)
          ? (cartItem['price'] as int).toDouble()
          : (cartItem['price'] ?? 0.0);

      final addons = cartItem['addons'] as List<dynamic>? ?? [];

      double addonsTotal = 0;
      for (final addon in addons) {
        double addonPrice = (addon['price'] is int)
            ? (addon['price'] as int).toDouble()
            : (addon['price'] ?? 0.0);
        addonsTotal += addonPrice;
      }

      totalItems += quantity;
      totalPrice += quantity * (price + addonsTotal);
    }

    final deliveryTime = DateTime.now().add(Duration(minutes: 30)).toIso8601String();

    final orderData = {
      "userId": userId,
      "items": cartItems,
      "total_items": totalItems,
      "total_price": totalPrice,
      "delivery_time": deliveryTime,
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5001/api/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      final resData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _orderPlaced = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resData['message'] ?? 'Order placed')),
        );
      } else {
        print("Error placing order: ${resData['error']}");
      }
    } catch (e) {
      print("Failed to place order: $e");
    }
  }

  // ✅ Correctly placed build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery in process'),
        backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : MyReceipt(Restaurant().generateReceipt(userCart)),
        ),
      ),
    );
  }

  // ✅ No override needed here
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
              ),
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
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              Text(
                "Driver",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  shape: BoxShape.circle,
                ),
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
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.call),
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
