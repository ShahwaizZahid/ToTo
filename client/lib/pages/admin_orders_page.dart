import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/my_admin_order_tile.dart';

class AdminAllOrdersPage extends StatefulWidget {
  const AdminAllOrdersPage({super.key});

  @override
  State<AdminAllOrdersPage> createState() => _AdminAllOrdersPageState();
}

class _AdminAllOrdersPageState extends State<AdminAllOrdersPage> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5001/api/get_all_orders'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          orders = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch orders");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> markOrderAsSuccess(String orderId) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:5001/api/mark_order_success/$orderId'),
    );
    if (response.statusCode == 200) {
      fetchOrders(); // Refresh list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to update order")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingOrders = orders.where((o) => o['orderStatus'] == 'Pending').toList();
    final successOrders = orders.where((o) => o['orderStatus'] == 'Success').toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("All Orders"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "All"),
              Tab(text: "Pending"),
              Tab(text: "Success"),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            _buildOrderList(orders),
            _buildOrderList(pendingOrders),
            _buildOrderList(successOrders),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> list) {
    if (list.isEmpty) return const Center(child: Text("No orders"));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: list.map((order) {
        return MyAdminOrderTile(
          order: order,
          onMarkSuccess: order['orderStatus'] == 'Pending'
              ? () => markOrderAsSuccess(order['_id'])
              : null,
        );
      }).toList(),
    );
  }
}
