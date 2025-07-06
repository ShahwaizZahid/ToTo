import 'package:client/components/my_button.dart';
import 'package:client/components/my_cart_tile.dart';
import 'package:client/models/restaurant.dart';
import 'package:client/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List userCart = [];
  bool isLoading = false;
  bool isCartLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartItems().then((items) {
      setState(() {
        userCart = items;
        isCartLoading = false;
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
      final baseUrl = dotenv.env['BASE_URL'];
      if (baseUrl == null || baseUrl.isEmpty) {
        showMessage('BASE_URL not configured');
        return [];
      }
      setState(() {
        isLoading = true;
      });


      final url = Uri.parse('$baseUrl/get_cart_items?userId=$userId');

      final response = await http.get(url);


      if (response.statusCode == 200) {
        final List<dynamic> cartItems = jsonDecode(response.body);
        return cartItems;
      } else {
        showMessage(
          'Failed to load cart items. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      showMessage('Error loading cart items: $e');
    }

    return [];
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, retanurant, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: Text('Cart', style: TextStyle()),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              IconButton(
                onPressed: () {
                  if (userCart.isEmpty) {
                    return;
                  }
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text(
                            'Are you sure you want to clear the cart?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);

                                setState(() {
                                  isLoading = true;
                                });

                                final prefs =
                                    await SharedPreferences.getInstance();
                                final userId = prefs.getString('UserId');

                                final baseUrl = dotenv.env['BASE_URL'];
                                if (baseUrl == null || baseUrl.isEmpty) {
                                  showMessage('BASE_URL not configured');
                                  return ;
                                }
                                if (userId != null) {
                                  final url = Uri.parse('$baseUrl/clear_cart?userId=$userId');

                                  final response = await http.post(
                                    url, // ✅ use url directly, don't parse it again
                                  );

                                  if (response.statusCode == 200) {
                                    setState(() {
                                      userCart.clear();
                                      isLoading = false;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Cart cleared successfully!',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to clear cart.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('User ID not found.'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                }
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                  );
                },

                icon: Icon(
                  userCart.isEmpty ? Icons.shopping_cart : Icons.delete,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child:
                    isCartLoading
                        ? Center(child: CircularProgressIndicator())
                        : userCart.isEmpty
                        ? Center(
                          child: Text(
                            'Cart is empty.......',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: userCart.length,
                          itemBuilder: (context, index) {
                            final cartItem = userCart[index];
                            return MyCartTile(cartItem: cartItem);
                          },
                        ),
              ),
              MyButton(
                onTap:
                    () => {
                      if (userCart.isNotEmpty)
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(),
                            ),
                          ),
                        }
                      else
                        {showMessage('First add items in cart for checkout')},
                    },
                text: 'Go to checkout',
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
