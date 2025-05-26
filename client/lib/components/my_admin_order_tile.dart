import 'package:flutter/material.dart';

class MyAdminOrderTile extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback? onMarkSuccess;

  const MyAdminOrderTile({
    super.key,
    required this.order,
    this.onMarkSuccess,
  });

  @override
  Widget build(BuildContext context) {
    List items = order['items'];

    return Card(
      color: Theme.of(context).colorScheme.background,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${order['_id']}", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("Total Items: ${order['total_items']} | Total Price: \$${order['total_price'].toStringAsFixed(2)}"),
            const SizedBox(height: 10),
            ...items.map<Widget>((item) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text("Qty: ${item['count']}  |  \$${item['price']}"),
                ],
              );
            }).toList(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status: ${order['orderStatus']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: order['orderStatus'] == 'Pending' ? Colors.orange : Colors.green,
                  ),
                ),
                if (order['orderStatus'] == 'Pending')
                  ElevatedButton(
                    onPressed: onMarkSuccess,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text("Mark as Success"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
