import 'package:client/pages/admin_page.dart';
import 'package:client/components/my_button.dart';
import 'package:client/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginAdmin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showMessage('Please fill in all fields');
      return;
    }

    final url = Uri.parse('http://10.0.2.2:5001/admin/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        showMessage(data['message']);

        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminPage()),
                (route) => false,
          );
        });
      } else {
        showMessage(data['message']);
      }
    } catch (e) {
      showMessage('Login failed: $e');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.admin_panel_settings,
                  size: 100,
                  color: Theme.of(context).colorScheme.inversePrimary),
              const SizedBox(height: 20),
              Text(
                "Admin Login Panel",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
              const SizedBox(height: 30),
              MyTextField(
                  controller: usernameController,
                  hintText: "Username",
                  obscureText: false),
              const SizedBox(height: 12),
              MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true),
              const SizedBox(height: 25),
              MyButton(onTap: loginAdmin, text: "Login as Admin"),
              const SizedBox(height: 20),
              Text("Authorized access only",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary))
            ],
          ),
        ),
      ),
    );
  }
}
