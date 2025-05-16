import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCurrentLoaction extends StatelessWidget {
  const MyCurrentLoaction({super.key});
  void openLoactionBox(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Your Loaction" , style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              )),
              content: TextField(
                decoration: InputDecoration(hintText: "search address"),
              ),
              actions: [
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Save"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deliver Now',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () => openLoactionBox(context),
            child: Row(
              children: [
                Text('6901 Hollywood Blv',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),),
                Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          )
        ],
      ),
    );
  }
}
