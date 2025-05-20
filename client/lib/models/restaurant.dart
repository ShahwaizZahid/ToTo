import 'package:client/models/card_item.dart';
import 'package:client/models/food.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class Restaurant extends ChangeNotifier {
  final List<Food> _menu = [];

  //   G E T T E R S
  List<Food> get menu => _menu;
  List get cart => _card;

  // O P E R A T I O N S
  final List _card = [];



  // Get Total price of card

  double getTotalPrice() {
    double total = 0.0;
    // for (cartItem in _card) {
    //   double itemTotal = cartItem.food.price;
    //
    //   for (addon in cartItem.selectedAddons) {
    //     itemTotal += addon.price;
    //   }

      // total += itemTotal * cartItem.quantity;
    // }

    return total;
  }


  // clear cart
  void clearCart() {
    _card.clear();
    notifyListeners();
  }

  // GENERATE RECEIPT
  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Here's your receipt. ");
    receipt.writeln();

    //      format the date to include up to seconds only
    String formattedDate = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now());
    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("----------------");

    for (final cartIten in _card) {
      // receipt.writeln(
      //   " ${cartIten.quantity} x ${cartIten.food.name} - ${_formatPrice(cartIten.food.price)}",
      // );
      if (cartIten.selectedAddons.isNotEmpty) {
        receipt.writeln(
          "     Add-ons: ${_formatAddons(cartIten.selectedAddons)} ",
        );
      }
      receipt.writeln();
    }
    receipt.writeln("--------------");
    receipt.writeln();
    receipt.writeln(" Total items:");
    receipt.writeln(" Total Price: ${_formatPrice(getTotalPrice())}");

    return receipt.toString();
  }

  // format price double value into money
  String _formatPrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }

  // Format a list of addons into a string summary
  String _formatAddons(List addons) {
    return addons
        .map((addon) => '${addon.name} (${_formatPrice(addon.price)})')
        .join(', ');
  }
}
