import 'package:client/components/my_current_loaction.dart';
import 'package:client/components/my_description_box.dart';
import 'package:client/components/my_drawer.dart';
import 'package:client/components/my_food_tile.dart';
import 'package:client/components/my_silver_app_bar.dart';
import 'package:client/components/my_tab_bar.dart';
import 'package:client/models/food.dart';
import 'package:client/pages/food_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Food> _fetchedMenu = [];
  bool _isLoading = true; // optional to show loading indicator

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: FoodCategory.values.length,
      vsync: this,
    );
    fetchMenuFromApi();
  }

  void fetchMenuFromApi() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5001/menu_list'),
      );

      if (response.statusCode == 200) {
        List<dynamic> menuJson = jsonDecode(response.body);
        List<Food> loadedMenu =
            menuJson.map((jsonItem) => Food.fromJson(jsonItem)).toList();

        setState(() {
          _fetchedMenu = loadedMenu;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu) {
    return fullMenu.where((food) => food.category == category).toList();
  }

  List<Widget> getFoodInThisCategory(List<Food> fullMenu) {
    return FoodCategory.values.map((category) {
      List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);
      return ListView.builder(
        itemCount: categoryMenu.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final food = categoryMenu[index];
          return MyFoodTile(
            food: food,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodPage(food: food)),
                ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              MySilverAppBar(
                title: MyTabBar(tabController: _tabController),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Divider(
                      indent: 25,
                      endIndent: 25,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const MyCurrentLoaction(),
                    const MyDescriptionBox(),
                  ],
                ),
              ),
            ],
        body:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                  controller: _tabController,
                  children: getFoodInThisCategory(_fetchedMenu),
                ),
      ),
    );
  }
}
