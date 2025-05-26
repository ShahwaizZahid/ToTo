import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Restaurant extends ChangeNotifier {
  // ===================================
  //        Reciept Generation
  // ===================================
  String generateReceipt(List cartData) {
    final receipt = StringBuffer();

    int totalItems = 0;
    double totalPrice = 0;

    for (final cartItem in cartData) {
      int quantity = (cartItem['count'] ?? 0).toInt();

      final name = cartItem['name'] ?? 'Unknown';

      final price =
          (cartItem['price'] is int)
              ? (cartItem['price'] as int).toDouble()
              : (cartItem['price'] ?? 0.0);

      final addons = cartItem['addons'] as List<dynamic>? ?? [];

      // Calculate total add-ons price
      double addonsTotalPrice = 0;
      for (final addon in addons) {
        double addonPrice = 0;
        if (addon is Map && addon.containsKey('price')) {
          addonPrice =
              (addon['price'] is int)
                  ? (addon['price'] as int).toDouble()
                  : (addon['price'] ?? 0.0);
        }
        addonsTotalPrice += addonPrice;
      }

      num itemBaseTotal = quantity * price;

      double itemAddonsTotal =
          quantity * addonsTotalPrice; // add-ons price per quantity

      double itemTotalPrice = itemBaseTotal + itemAddonsTotal;

      totalItems += quantity;
      totalPrice += itemTotalPrice;
      receipt.writeln("$quantity x $name - ${_formatPrice(price)} each");

      if (addons.isNotEmpty) {
        receipt.writeln("     Add-ons:");
        for (final addon in addons) {
          final addonName = addon['name'] ?? 'Addon';
          final addonPrice =
              (addon['price'] is int)
                  ? (addon['price'] as int).toDouble()
                  : (addon['price'] ?? 0.0);
          receipt.writeln("       - $addonName: ${_formatPrice(addonPrice)}");
        }
      }

      receipt.writeln("     Item total: ${_formatPrice(itemTotalPrice)}");
      receipt.writeln();
    }
    totalPrice += 0.20;

    // Calculate delivery time: now + 30 minutes
    final now = DateTime.now();
    final deliveryTime = now.add(Duration(minutes: 30));
    // Format delivery time nicely, e.g., "3:45 PM"
    final formattedDeliveryTime = DateFormat.jm().format(deliveryTime);

    receipt.writeln(
      "----------------------------------------------------------------",
    );
    receipt.writeln("Total items: $totalItems");
    receipt.writeln("Total Price: ${_formatPrice(totalPrice)}");
    receipt.writeln("Estimated Delivery Time: $formattedDeliveryTime");
    receipt.writeln(
      "----------------------------------------------------------------",
    );

    return receipt.toString();
  }

  // ===================================
  //        Price Format
  // ===================================
  String _formatPrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }
}
