import 'package:client/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmcontroller = TextEditingController();
  Future<void> registerUser() async {
    final email = emailcontroller.text.trim();
    final password = passwordcontroller.text.trim();
    final confirmPassword = confirmcontroller.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showMessage('Please fill all fields');
      return;
    }

    if (password != confirmPassword) {
      showMessage('Passwords do not match');
      return;
    }

    final url = Uri.parse('http://10.0.2.2:5001/signup');


    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        showMessage(data['message'] ?? 'Signup successful');
        Future.delayed(Duration(seconds: 1), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                LoginPage(), // dummy onTap if not needed
          ));
        });
      } else {
        showMessage(data['message'] ?? 'Signup failed');
      }
    } catch (e) {
      showMessage('Error: $e');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Login Page
            Icon(
              Icons.lock_open_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            SizedBox(height: 25),
            // Login Page Text
            Text(
              "Lets create an account for you",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            SizedBox(height: 25),
            // Email TextField
            MyTextField(
              controller: emailcontroller,
              hintText: 'Email',
              obscureText: false,
            ),
            SizedBox(height: 10),
            // Password TextField
            MyTextField(
              controller: passwordcontroller,
              hintText: 'Password',
              obscureText: true,
            ),
            SizedBox(height: 10),
            //confirm  Password TextField
            MyTextField(
              controller: confirmcontroller,
              hintText: ' Confirm Password',
              obscureText: true,
            ),
            SizedBox(height: 10),
            //  Register Button
            MyButton(onTap: registerUser, text: 'Register'),
            SizedBox(height: 25),
            // Already have an account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                const SizedBox(
                  width: 4,
                ),
                GestureDetector(
                  onTap: (){Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          LoginPage(), // dummy onTap if not needed
                      ));},
                  child: Text(
                    'Login now',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
