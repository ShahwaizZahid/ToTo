import 'package:client/models/restaurant.dart';
import 'package:client/pages/home_page.dart';
import 'package:client/pages/register_page.dart';
import 'package:client/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('loggedIn') ?? false;

  final themeProvider = ThemeProvider(); // Will auto-load theme inside

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider(create: (context) => Restaurant()),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}


class MyApp extends StatelessWidget {

  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOTO',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: isLoggedIn ? const HomePage() :  RegisterPage(),
    );
  }
}
