class CartItem {
  final String cartItemId;
  final String imagePath;
  final String name;
  final double price;
  final int count;
  final List<Addon> addons;

  CartItem({
    required this.cartItemId,
    required this.imagePath,
    required this.name,
    required this.price,
    required this.count,
    required this.addons,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'],
      imagePath: json['imagePath'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      count: json['count'],
      addons: (json['addons'] as List)
          .map((addon) => Addon.fromJson(addon))
          .toList(),
    );
  }
}

class Addon {
  final String name;
  final double price;

  Addon({required this.name, required this.price});

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      name: json['name'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
