import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    fetchCartItems().then((items) {
      setState(() {
        userCart = items;
        isLoading = false;
      });
    });
  }

  Future<List<dynamic>> fetchCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('UserId');
    if (userId == null) {
      return [];
    }

    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5001/get_cart_items?userId=$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> cartItems = jsonDecode(response.body);
        return cartItems;
      } else {
        print('Failed to load cart items. Status code: ${response.statusCode}');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading cart items: $e');
    }

    return [];
  }

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
          child:
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : MyReceipt(Restaurant().generateReceipt(userCart)),
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
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          // Profile Pic of  Deliver
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
