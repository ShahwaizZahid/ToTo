import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../components/my_delete_food_tile.dart';
import '../models/food.dart';

class DeleteFoodPage extends StatefulWidget {
  const DeleteFoodPage({super.key});

  @override
  State<DeleteFoodPage> createState() => _DeleteFoodPageState();
}

class _DeleteFoodPageState extends State<DeleteFoodPage> {
  List<Food> foodList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFoodItems();
  }

  Future<void> fetchFoodItems() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5001/menu_list'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          foodList = data.map((item) => Food.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load food items');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching food: $e')),
      );
    }
  }

  Future<void> deleteFood(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this food item?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final response = await http.delete(Uri.parse('http://10.0.2.2:5001/api/admin/food/delete/$id'));

      if (response.statusCode == 200) {
        setState(() {
          foodList.removeWhere((food) => food.id == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Food deleted successfully')));
      } else {
        throw Exception('Failed to delete');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Foods'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : foodList.isEmpty
          ? const Center(child: Text('No food items available'))
          : ListView.builder(
        itemCount: foodList.length,
        padding: const EdgeInsets.only(bottom: 20),
        itemBuilder: (context, index) {
          final food = foodList[index];
          return DeleteFoodTile(
            food: food,
            onDelete: () => deleteFood(food.id),
          );
        },
      ),
    );
  }
}
