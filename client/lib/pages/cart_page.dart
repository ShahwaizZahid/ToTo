import 'package:client/components/my_button.dart';
import 'package:client/components/my_cart_tile.dart';
import 'package:client/models/restaurant.dart';
import 'package:client/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/card_item.dart';
import '../models/food.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List userCart = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCartItems().then((items) {
      setState(() {
        userCart = items;
      });
    });
  }

  Future<List<dynamic>> fetchCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('UserId');
    if (userId == null) {
      return [];
    }

    try {
      setState(() {
        isLoading= true;
      });
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5001/get_cart_items?userId=$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> cartItems = jsonDecode(response.body); // ✅ directly parse as List
        return cartItems;
      } else {
        print('Failed to load cart items. Status code: ${response.statusCode}');
      }
      setState(() {
        isLoading= false;
      });
    } catch (e) {
      setState(() {
        isLoading= false;
      });
      print('Error loading cart items: $e');
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, retanurant, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: Text('Cart', style: TextStyle(
            ),),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text(
                                  'Are you sure you want to clear the cart'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('cancel')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      retanurant.clearCart();
                                    },
                                    child: const Text('yes'))
                              ],
                            ));
                  },
                  icon: Icon( userCart.isEmpty ?Icons.shopping_cart :Icons.delete))
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                     userCart.isEmpty
                        ? Expanded(
                      child: Center(
                        child: Text(
                          'Cart is empty.......',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                    )
                        : Expanded(
                      child: ListView.builder(
                        itemCount: userCart.length,
                        itemBuilder: (context, index) {
                          final cartItem = userCart[index];
                          return MyCartTile(cartItem: cartItem);
                        },
                      ),
                    )
                  ],
                ),
              ),
              MyButton(
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(),
                        ),
                      ),
                  text: 'Go to checkout'),
              const SizedBox(height: 20)
            ],
          ),
        );
      },
    );
  }
}
