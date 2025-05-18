class Food {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final FoodCategory category;
  List<Addon> availableAddons;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.availableAddons,
    required this.category,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      price: (json['price'] as num).toDouble(),
      availableAddons: (json['availableAddons'] as List<dynamic>?)
          ?.map((addonJson) => Addon.fromJson(addonJson))
          .toList() ??
          [],
      category: FoodCategory.values.firstWhere(
              (e) => e.toString() == 'FoodCategory.${json['category']}',
          orElse: () => FoodCategory.burgers),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'price': price,
      'availableAddons': availableAddons.map((a) => a.toJson()).toList(),
      'category': category.toString().split('.').last,
    };
  }
}

enum FoodCategory {
  burgers,
  salads,
  sides,
  desserts,
  drinks,
}

class Addon {
  String name;
  double price;

  Addon({required this.name, required this.price});

  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}
