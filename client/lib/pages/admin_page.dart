import 'dart:convert';
import 'package:client/pages/add_food_page.dart';
import 'package:client/pages/admin_login_page.dart';
import 'package:client/pages/admin_orders_page.dart';
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
  late int ordersLength = 0;
  List<Map<String, dynamic>> orders = [];
  Future<void> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5001/api/admin/users'),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          userLength = data['length'];
        });
      } else {
        _showSnackBar('Failed to load users');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  Future<void> fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5001/api/get_all_orders'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          orders = List<Map<String, dynamic>>.from(data);
          ordersLength = orders.length;
        });
      } else {
        throw Exception("Failed to fetch orders");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Panel',
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("🍽️ Menu Management"),
            _buildAdminTile(Icons.list, "View All Orders", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminAllOrdersPage()),
              );
            }),
            _buildAdminTile(Icons.add_circle_outline, "Add New Food", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddFoodPage()),
              );
            }),
            _buildAdminTile(Icons.delete_outline, "Delete Food", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeleteFoodPage()),
              );
            }),
            const SizedBox(height: 20),
            _sectionTitle("👥 User Management"),
            _buildAdminTile(Icons.people, "View Registered Users", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisteredUsersPage()),
              );
            }),
            const SizedBox(height: 25),
            _sectionTitle("📊 Stats"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard("Orders", "$ordersLength", Icons.shopping_cart),
                _buildStatCard("Users", "$userLength", Icons.people),
              ],
            ),
            const SizedBox(height: 30),
            _sectionTitle("⚙️ Settings"),
            _buildSettingTile(
              title: "Dark Mode",
              icon: Icons.dark_mode,
              trailing: CupertinoSwitch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(),
              ),
            ),
            const SizedBox(height: 20),
            _buildLogoutTile(),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  Widget _buildAdminTile(IconData icon, String title, VoidCallback onTap) {
    return Card(
      color: Theme.of(context).colorScheme.background,
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatCard(String label, String count, IconData icon) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background, // 🔵 background color
        border: Border.all(
          color: Theme.of(context).colorScheme.inversePrimary, // ⚪ border color
          width: 2,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),

      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            child: Icon(
              icon,
              size: 24,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required IconData icon,
    required Widget trailing,
  }) {
    return Card(
      color: Theme.of(context).colorScheme.background,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        trailing: trailing,
      ),
    );
  }

  Widget _buildLogoutTile() {
    return Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text(
          "Log Out",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('adminLoggedIn', false);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminLoginPage()),
            (route) => false,
          );
        },
      ),
    );
  }
}
