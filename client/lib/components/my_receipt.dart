import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/restaurant.dart';

class MyReceipt extends StatelessWidget {
  const MyReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 25, right: 25, top: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Thank you for your order!"),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                border: Border.all( color: Theme.of(context).colorScheme.secondary),
                borderRadius: BorderRadius.circular(8)
              ),
              padding: const EdgeInsets.all(25),
              child: Consumer<Restaurant>(builder:(context, restaurant , child) => Text(restaurant.displayCartReceipt())),
            ),
            const SizedBox(height: 25),
            const Text("Estimate delivery time 4:10PM"),

          ],
        ),
      ),
    );
  }
}
