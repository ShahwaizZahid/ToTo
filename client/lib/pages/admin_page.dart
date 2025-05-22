import 'dart:convert';

import 'package:client/pages/add_food_page.dart';
import 'package:client/pages/admin_login_page.dart';
import 'package:client/pages/delete_food_page.dart';
import 'package:client/pages/registered_user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../themes/theme_provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late int userLength = 0;

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5001/api/admin/users'));
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          userLength = data['length'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load users')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(" Menu Management", style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 10),
            _buildAdminTile(context, Icons.list, "View All Orders", () {
              // Navigate or show dialog
            }),
            _buildAdminTile(context, Icons.add_circle_outline, "Add  New Food", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddFoodPage()),
              );
            }),
            _buildAdminTile(context, Icons.delete_outline, "Delete  Food", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeleteFoodPage()),
              );
            }),
            _buildAdminTile(context, Icons.people, "View Registered Users", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisteredUsersPage()),
              );
            }),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard("Orders", "128", Icons.shopping_cart),
                _buildStatCard("Users", "$userLength", Icons.people),
              ],
            ),
            Card(
              margin: EdgeInsets.only(top: 30),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text("Log Out"),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('loggedIn', false);
                  final userId = prefs.remove('userId');

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLoginPage()),
                        (Route<dynamic> route) =>
                    false, // this removes all previous routes
                  );
                },
              ),
            ),

            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dark Mode',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.inversePrimary),
                      ),
                      CupertinoSwitch(
                        value: Provider.of<ThemeProvider>(context).isDarkMode,
                        onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                      ),

                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatCard(String label, String count, IconData icon) {
    return Card(
      elevation: 2,
      child: Container(
        width: 120,
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            SizedBox(height: 8),
            Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
