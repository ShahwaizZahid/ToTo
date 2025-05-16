import 'package:client/models/card_item.dart';
import 'package:client/models/food.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import 'food.dart';

class Restaurant extends ChangeNotifier {
  List<Food> _menu = [
    //  burgers
    Food(
      name: 'Cheeseburger Deluxe',
      description:
          'A premium cheeseburger with double beef patties, cheddar cheese, and fresh toppings.',
      imagePath:
          'assets/images/burgers/cheese_burger.jpeg', // Changed image path to JPEG
      price: 6.99, // Updated price
      availableAddons: [
        Addon(name: 'Double Cheese', price: 1.25),
        Addon(name: 'Bacon', price: 1.75),
        Addon(name: 'Pickles', price: 0.75),
        Addon(name: 'Extra Patty', price: 2.00),
      ],
      category: FoodCategory.burgers, // Same category
    ),
    Food(
      name: 'Spicy Patti Burger',
      description:
          'A hot and spicy patti burger with jalapenos and tangy hot sauce.',
      imagePath:
          'assets/images/burgers/pati_burger.jpeg', // Changed to JPEG format
      price: 5.49, // Updated price
      availableAddons: [
        Addon(name: 'Extra Hot Sauce', price: 0.75),
        Addon(name: 'Grilled Onions', price: 0.75),
        Addon(name: 'Avocado', price: 1.50),
        Addon(name: 'Cheddar Cheese', price: 1.00),
      ],
      category: FoodCategory.burgers, // Same category
    ),
    Food(
      name: 'Sunny Side Egg Burger',
      description:
          'A juicy beef burger topped with a sunny-side-up egg and fresh veggies.',
      imagePath: 'assets/images/burgers/egg_burger.jpeg', // Updated image path
      price: 4.99, // Adjusted price
      availableAddons: [
        Addon(name: 'Extra Egg', price: 1.50),
        Addon(name: 'Avocado', price: 1.50),
        Addon(name: 'Cheddar Cheese', price: 1.00),
        Addon(name: 'Grilled Mushrooms', price: 1.00),
      ],
      category: FoodCategory.burgers, // Same category
    ),
    Food(
      name: 'Ultimate Zinger Burger',
      description:
          'A crispy chicken zinger burger with fresh lettuce and spicy mayo.',
      imagePath: 'assets/images/burgers/zinger_burger.jpeg', // Updated to JPEG
      price: 6.49, // Updated price
      availableAddons: [
        Addon(name: 'Extra Crispy Chicken', price: 2.00),
        Addon(name: 'Pepper Jack Cheese', price: 1.00),
        Addon(name: 'Spicy Mayo', price: 0.75),
        Addon(name: 'Onion Rings', price: 1.25),
      ],
      category: FoodCategory.burgers, // Same category
    ),
    Food(
      name: 'Fully Loaded Burger',
      description:
          'A massive burger loaded with bacon, cheese, and caramelized onions.',
      imagePath:
          'assets/images/burgers/loaded_burger.jpeg', // Updated image path
      price: 7.49, // Adjusted price
      availableAddons: [
        Addon(name: 'Extra Bacon', price: 1.75),
        Addon(name: 'Cheddar Cheese', price: 1.25),
        Addon(name: 'BBQ Sauce', price: 1.00),
        Addon(name: 'Fried Egg', price: 1.50),
      ],
      category: FoodCategory.burgers, // Same category
    ),

    // salads
    Food(
      name: 'Caesar Salad',
      description:
          'Crisp romaine lettuce tossed with Caesar dressing, croutons, and parmesan cheese.',
      imagePath:
          'assets/images/salads/caesar_salad.jpeg', // Update with the correct image path
      price: 7.99,
      availableAddons: [
        Addon(name: 'Grilled Chicken', price: 2.00),
        Addon(name: 'Bacon Bits', price: 1.00),
        Addon(name: 'Extra Dressing', price: 0.50),
      ],
      category: FoodCategory.salads, // Category
    ),
    Food(
      name: 'Caprese Salad',
      description:
          'Fresh mozzarella, tomatoes, and basil drizzled with balsamic glaze.',
      imagePath: 'assets/images/salads/caprese_salad.jpeg',
      price: 8.49,
      availableAddons: [
        Addon(name: 'Balsamic Reduction', price: 0.75),
        Addon(name: 'Avocado', price: 1.25),
      ],
      category: FoodCategory.salads,
    ),
    Food(
      name: 'Cobb Salad',
      description:
          'A classic Cobb salad with chicken, bacon, avocado, hard-boiled eggs, and blue cheese.',
      imagePath:
          'assets/images/salads/cobb_salad.jpeg', // Update with the correct image path
      price: 9.49,
      availableAddons: [
        Addon(name: 'Extra Chicken', price: 2.00),
        Addon(name: 'Extra Cheese', price: 0.75),
      ],
      category: FoodCategory.salads,
    ),
    Food(
      name: 'Greek Salad',
      description:
          'A refreshing Greek salad with cucumbers, tomatoes, olives, and feta cheese.',
      imagePath:
          'assets/images/salads/greek_salad.jpeg', // Update with the correct image path
      price: 8.99,
      availableAddons: [
        Addon(name: 'Extra Feta', price: 1.00),
        Addon(name: 'Tzatziki Sauce', price: 0.50),
      ],
      category: FoodCategory.salads,
    ),
    Food(
      name: 'Waldorf Salad',
      description:
          'A delicious Waldorf salad made with apples, walnuts, and grapes in a creamy dressing.',
      imagePath:
          'assets/images/salads/waldorf_salad.jpeg', // Update with the correct image path
      price: 7.49,
      availableAddons: [
        Addon(name: 'Extra Walnuts', price: 0.75),
        Addon(name: 'Dried Cranberries', price: 0.50),
      ],
      category: FoodCategory.salads,
    ),

    //   desserts
    Food(
      name: 'Cheesecake',
      description:
          'A rich and creamy cheesecake with a buttery graham cracker crust.',
      imagePath:
          'assets/images/desserts/cheesecake_dessert.jpeg', // Update with the correct image path
      price: 4.99,
      availableAddons: [
        Addon(name: 'Strawberry Sauce', price: 0.75),
        Addon(name: 'Whipped Cream', price: 0.50),
      ],
      category: FoodCategory.desserts, // Category
    ),
    Food(
      name: 'Tiramisu',
      description:
          'A classic Italian dessert made with layers of coffee-soaked ladyfingers and mascarpone cheese.',
      imagePath:
          'assets/images/desserts/tiramisu_dessert.jpeg', // Update with the correct image path
      price: 5.49,
      availableAddons: [
        Addon(name: 'Extra Cocoa Powder', price: 0.50),
        Addon(name: 'Chocolate Shavings', price: 0.75),
      ],
      category: FoodCategory.desserts,
    ),
    Food(
      name: 'Brownie',
      description:
          'A fudgy brownie topped with chocolate ganache and served warm.',
      imagePath:
          'assets/images/desserts/brownie_dessert.jpeg', // Update with the correct image path
      price: 3.99,
      availableAddons: [
        Addon(name: 'Vanilla Ice Cream', price: 1.50),
        Addon(name: 'Chocolate Sauce', price: 0.50),
      ],
      category: FoodCategory.desserts,
    ),
    Food(
      name: 'Panna Cotta',
      description:
          'A creamy Italian dessert made with sweetened cream thickened with gelatin and served with berry coulis.',
      imagePath:
          'assets/images/desserts/panna_cotta_dessert.jpeg', // Update with the correct image path
      price: 4.49,
      availableAddons: [
        Addon(name: 'Berry Compote', price: 0.75),
        Addon(name: 'Mint Leaves', price: 0.50),
      ],
      category: FoodCategory.desserts,
    ),
    Food(
      name: 'Éclair',
      description:
          'A light and airy pastry filled with cream and topped with chocolate glaze.',
      imagePath:
          'assets/images/desserts/eclair_dessert.jpeg', // Update with the correct image path
      price: 3.49,
      availableAddons: [
        Addon(name: 'Extra Cream Filling', price: 0.75),
        Addon(name: 'Sprinkles', price: 0.25),
      ],
      category: FoodCategory.desserts,
    ),

    //   sides
    Food(
      name: 'Garlic Bread',
      description: 'Toasted bread topped with garlic butter and parsley.',
      imagePath:
          'assets/images/sides/garlic_bread_side.jpeg', // Update with the correct image path
      price: 3.49,
      availableAddons: [
        Addon(name: 'Cheese', price: 0.75),
        Addon(name: 'Extra Garlic', price: 0.50),
      ],
      category: FoodCategory.sides, // Category
    ),
    Food(
      name: 'Mashed Potatoes',
      description: 'Creamy mashed potatoes whipped to perfection.',
      imagePath:
          'assets/images/sides/mashed_potatoes_side.jpeg', // Update with the correct image path
      price: 4.29,
      availableAddons: [
        Addon(name: 'Gravy', price: 0.75),
        Addon(name: 'Butter', price: 0.50),
      ],
      category: FoodCategory.sides,
    ),
    Food(
      name: 'Coleslaw',
      description:
          'Crunchy cabbage and carrot salad tossed in a creamy dressing.',
      imagePath:
          'assets/images/sides/coleslaw_side.jpeg', // Update with the correct image path
      price: 2.99,
      availableAddons: [
        Addon(name: 'Extra Dressing', price: 0.50),
        Addon(name: 'Sunflower Seeds', price: 0.75),
      ],
      category: FoodCategory.sides,
    ),
    Food(
      name: 'Roasted Vegetables',
      description: 'A medley of seasonal vegetables roasted to perfection.',
      imagePath:
          'assets/images/sides/roasted_vegetables_side.jpeg', // Update with the correct image path
      price: 4.99,
      availableAddons: [
        Addon(name: 'Balsamic Glaze', price: 0.75),
        Addon(name: 'Herbs', price: 0.50),
      ],
      category: FoodCategory.sides,
    ),
    Food(
      name: 'French Fries',
      description: 'Crispy golden fries seasoned to perfection.',
      imagePath:
          'assets/images/sides/french_fries_side.jpeg', // Update with the correct image path
      price: 3.49,
      availableAddons: [
        Addon(name: 'Cheese Sauce', price: 1.00),
        Addon(name: 'Spicy Ketchup', price: 0.50),
      ],
      category: FoodCategory.sides,
    ),

    //   drinks
    Food(
      name: 'Lemonade',
      description: 'Freshly squeezed lemonade with a hint of mint.',
      imagePath:
          'assets/images/drinks/lemonade_drink.jpeg', // Update with the correct image path
      price: 2.99,
      availableAddons: [
        Addon(name: 'Extra Lemon', price: 0.50),
        Addon(name: 'Mint Leaves', price: 0.25),
      ],
      category: FoodCategory.drinks, // Category
    ),
    Food(
      name: 'Iced Tea',
      description:
          'Refreshing iced tea served with lemon and a hint of sweetness.',
      imagePath:
          'assets/images/drinks/iced_tea_drink.jpeg', // Update with the correct image path
      price: 2.49,
      availableAddons: [
        Addon(name: 'Peach Flavor', price: 0.75),
        Addon(name: 'Extra Ice', price: 0.25),
      ],
      category: FoodCategory.drinks,
    ),
    Food(
      name: 'Mojito',
      description:
          'A classic mojito with fresh mint, lime, and rum (non-alcoholic available).',
      imagePath:
          'assets/images/drinks/mojito_drink.jpeg', // Update with the correct image path
      price: 4.99,
      availableAddons: [
        Addon(name: 'Extra Mint', price: 0.50),
        Addon(name: 'Lime Wedge', price: 0.25),
      ],
      category: FoodCategory.drinks,
    ),
    Food(
      name: 'Smoothie',
      description: 'A blend of fresh fruits and yogurt for a refreshing drink.',
      imagePath:
          'assets/images/drinks/smoothie_drink.jpeg', // Update with the correct image path
      price: 3.99,
      availableAddons: [
        Addon(name: 'Protein Powder', price: 1.00),
        Addon(name: 'Chia Seeds', price: 0.50),
      ],
      category: FoodCategory.drinks,
    ),
    Food(
      name: 'Espresso',
      description:
          'A strong and bold shot of espresso made from premium coffee beans.',
      imagePath:
          'assets/images/drinks/espresso_drink.jpeg', // Update with the correct image path
      price: 2.49,
      availableAddons: [
        Addon(name: 'Sugar', price: 0.25),
        Addon(name: 'Cream', price: 0.50),
      ],
      category: FoodCategory.drinks,
    ),
  ];

//   G E T T E R S
  List<Food> get menu => _menu;
 List<CardItem> get cart => _card;


// O P E R A T I O N S
  final List<CardItem> _card = [];

// Add to cart
  void addToCard(Food food, List<Addon> selectedAddons) {
    // Check if the food with the same addons already exists in the cart

    print(_card.length);
    CardItem? cardItem = _card.firstWhereOrNull((item) {
      bool isSameFood = item.food == food;
      bool isAddons =
          ListEquality().equals(item.selectedAddons, selectedAddons);
      return isSameFood && isAddons;
    });
    print(cardItem);
    if (cardItem != null) {
      cardItem.quantity++;
    } else {
      _card.add(CardItem(food: food, selectedAddons: selectedAddons));
    }
    print(_card.length);
    notifyListeners();
  }

//   Remove From  Card
void removeFromCard(CardItem cardItem){
    int cardIndex= _card.indexOf(cardItem);
    if(cardIndex != -1){
      if(_card[cardIndex].quantity > 1){
_card[cardIndex].quantity--;
      }else{
        _card.removeAt(cardIndex);
      }
    }
    notifyListeners();
}

// Get Total price of card

double getTotalPrice(){
    double total = 0.0;
    for(CardItem cartItem in _card){
      double itemTotal = cartItem.food.price;

      for(Addon addon in  cartItem.selectedAddons){
        itemTotal += addon.price;
      }

      total +=  itemTotal * cartItem.quantity;
    }

    return total;
}

// get total numbers of  item in card
int getTotalItemCount(){
    int totalItemCount = 0;

    for(CardItem cartItem in _card){
      totalItemCount += cartItem.quantity;
    }
    return totalItemCount;
}


// clear cart
void clearCart(){
    _card.clear();
    notifyListeners();
}


// GENERATE RECEIPT
String displayCartReceipt(){
     final receipt = StringBuffer();
     receipt.writeln("Here's your receipt. ");
     receipt.writeln();

//      format the date to include up to seconds only
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()) ;
  receipt.writeln(formattedDate);
  receipt.writeln();
  receipt.writeln("----------------");

  for(final cartIten in _card){
    receipt.writeln(" ${cartIten.quantity} x ${cartIten.food.name} - ${_formatPrice(cartIten.food.price)}");
    if(cartIten.selectedAddons.isNotEmpty){
      receipt.writeln("     Add-ons: ${_formatAddons(cartIten.selectedAddons)} ");
    }
    receipt.writeln();
  }
  receipt.writeln("--------------");
  receipt.writeln();
  receipt.writeln(" Total items: ${getTotalItemCount()}");
  receipt.writeln(" Total Price: ${_formatPrice(getTotalPrice())}");

  return receipt.toString();
}


// format price double value into money
  String _formatPrice(double price) {
    return "\$${price.toStringAsFixed(2)}";
  }

// Format a list of addons into a string summary
  String _formatAddons(List<Addon> addons) {
    return addons.map((addon) => '${addon.name} (${_formatPrice(addon.price)})').join(', ');
  }


}
