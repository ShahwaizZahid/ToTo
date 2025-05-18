import 'package:flutter/material.dart';

import 'my_quantity_selector.dart';

class MyCartTile extends StatelessWidget {
  final Map<String, dynamic> cartItem;
  const MyCartTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final foodName = cartItem['name'] ?? 'Unnamed';
    final imagePath = cartItem['imagePath'] ?? '';
    final price = cartItem['price']?.toStringAsFixed(2) ?? '0.00';
    final addons = cartItem['addons'] as List<dynamic>? ?? [];
    final quantity = cartItem['count'];
    final cartId = cartItem['cartItemId'] ?? "asdf";
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.inversePrimary),
          borderRadius: BorderRadius.circular(12),
        ),
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
                            color:
                            Theme.of(context).colorScheme.inversePrimary),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '\$$price',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(height: 10),
                      MyQuantitySelector(
                      quantity: quantity,
                      cartId: cartId,
                      onIncrement: () {},
                      onDecrement: () {}),
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
                  children: addons.map((addon) {
                    final name = addon['name'] ?? '';
                    final addonPrice = addon['price']?.toStringAsFixed(2) ?? '0.00';

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Row(
                          children: [
                            Text(name),
                            Text(' (\$$addonPrice)'),
                          ],
                        ),
                        shape: StadiumBorder(
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.primary)),
                        onSelected: (value) {},
                        backgroundColor:
                        Theme.of(context).colorScheme.secondary,
                        labelStyle: TextStyle(
                            color:
                            Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 12),
                      ),
                    );
                  }).toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
