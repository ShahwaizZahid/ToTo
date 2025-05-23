// my_order_food_tile.dart

import 'package:flutter/material.dart';

class MyOrderFoodTile extends StatelessWidget {
  final Map<String, dynamic> food;

  const MyOrderFoodTile({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food['name'] ?? '',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary)),
                  Text("Qty: ${food['count'] ?? 1}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary)),
                  Text("\$${food['price'].toString()}",
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                food['imagePath'] ?? '',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Divider(color: Colors.grey[300]),
      ],
    );
  }
}
