import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../components/my_order_food_tile.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Map<String, dynamic>> allOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('UserId');

      if (userId == null) {
        throw Exception("User not logged in");
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:5001/api/get_all_orders'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Filter orders by userId
        final userOrders =
            data.where((order) => order['userId'] == userId).toList();

        setState(() {
          allOrders = List<Map<String, dynamic>>.from(userOrders);
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to load orders")));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingOrders =
        allOrders.where((order) => order['orderStatus'] == 'Pending').toList();
    final successOrders =
        allOrders.where((order) => order['orderStatus'] == 'Success').toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        title: Text(
          "Orders",
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSectionTitle(context, "Pending Orders"),
                    if (pendingOrders.isEmpty) const Text("No pending orders"),
                    ...pendingOrders.map(
                      (order) => _buildOrderSection(order, context),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle(context, "Success Orders"),
                    if (successOrders.isEmpty)
                      const Text("No successful orders"),
                    ...successOrders.map(
                      (order) => _buildOrderSection(order, context),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(context).colorScheme.inversePrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildOrderSection(Map<String, dynamic> order, BuildContext context) {
    List items = order['items'];

    return Card(
      color: Theme.of(context).colorScheme.background,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color:
              Theme.of(context).colorScheme.inversePrimary, // Border color here
          width: 1.5, // Border width
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID: ${order['_id']}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Total Items: ${order['total_items']} | Total Price: \$${order['total_price'].toStringAsFixed(2)}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children:
                  items.map<Widget>((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: MyOrderFoodTile(food: item),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 4),
            Text(
              "Status: ${order['orderStatus']}",
              style: TextStyle(
                color:
                    order['orderStatus'] == 'Pending'
                        ? Colors.orange
                        : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
