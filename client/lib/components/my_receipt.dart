import 'package:flutter/material.dart';

class MyReceipt extends StatelessWidget {
  final String receipt;
  const MyReceipt(this.receipt, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 25, right: 25, top: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Thank you for your order!", style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold

            ),),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                border: Border.all( color: Theme.of(context).colorScheme.background, width: 2), // Border color and width
                borderRadius: BorderRadius.circular(16), // Optional: rounded corners
                color: Theme.of(context).colorScheme.background, // Optional: background color inside the border
              ),
              padding: const EdgeInsets.all(25),
              child: Text(receipt,
              style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
            ),
          ],
        ),
      ),
    );
  }
}
