import 'package:client/components/my_button.dart';
import 'package:client/components/my_cart_tile.dart';
import 'package:client/models/restaurant.dart';
import 'package:client/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, retanurant, child) {
        final userCart = retanurant.cart;
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
                        ? const Expanded(
                            child: Center(
                                child: Text(
                            'Cart is empty.......',
                            style: TextStyle(fontSize: 16),
                          )))
                        : Expanded(
                            child: ListView.builder(
                                itemCount: userCart.length,
                                itemBuilder: (context, index) {
                                  final cartItem = userCart[index];
                                  return MyCartTile(cartItem: cartItem);
                                }),
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
