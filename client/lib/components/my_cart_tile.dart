import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'my_quantity_selector.dart';

class MyCartTile extends StatefulWidget {
  final Map<String, dynamic> cartItem;
  const MyCartTile({super.key, required this.cartItem});

  @override
  _MyCartTileState createState() => _MyCartTileState();
}

class _MyCartTileState extends State<MyCartTile> {
  late int quantity;
  late String cartId;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    quantity = widget.cartItem['count'] ?? 1;
    cartId = widget.cartItem['cartItemId'] ?? '';
  }

  Future<void> updateQuantity(String method) async {
    if (isUpdating) return; // prevent double taps

    setState(() {
      isUpdating = true;
    });

    final url = Uri.parse('http://10.0.2.2:5001/cart/update_count');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'cart_id': cartId, 'method': method}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('count')) {
        setState(() {
          quantity = data['count'];
        });
      } else if (data['message'] == 'Item removed from cart') {
        // Optionally, remove item from UI or set quantity to zero
        setState(() {
          quantity = 0;
        });
      }
    }
    setState(() {
      isUpdating = false;
    });
  }

  void onIncrement() {
    updateQuantity('increment');
  }

  void onDecrement() {
    if (quantity > 1) {
      updateQuantity('decrement');
    } else {
      // If count would go below 1, maybe confirm deletion or just call update anyway
      updateQuantity('decrement');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (quantity == 0) {
      // Optionally hide the widget if quantity is 0 (item removed)
      return const SizedBox.shrink();
    }

    final foodName = widget.cartItem['name'] ?? 'Unnamed';
    final imagePath = widget.cartItem['imagePath'] ?? '';
    final price = (widget.cartItem['price'] ?? 0).toDouble().toStringAsFixed(2);
    final addons = widget.cartItem['addons'] as List<dynamic>? ?? [];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodName,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\$$price',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyQuantitySelector(
                      quantity: quantity,
                      cartId: cartId,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (addons.isNotEmpty)
            SizedBox(
              height: 60,
              child: ListView(
                padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                scrollDirection: Axis.horizontal,
                children:
                    addons.map((addon) {
                      final name = addon['name'] ?? '';
                      final addonPrice = (addon['price'] ?? 0)
                          .toDouble()
                          .toStringAsFixed(2);

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Row(
                            children: [Text(name), Text(' (\$$addonPrice)')],
                          ),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          onSelected: (value) {},
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
