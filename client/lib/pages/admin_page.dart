import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

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
            _buildAdminTile(context, Icons.add_circle_outline, "Add  New Food", () {// Navigate or show dialog
            }),
            _buildAdminTile(context, Icons.delete_outline, "Delete  Food", () {// Navigate or show dialog
            }),
            _buildAdminTile(context, Icons.fastfood, "Manage Menu Items", () {
              // Navigate or show dialog
            }),
            _buildAdminTile(context, Icons.people, "View Registered Users", () {
              // Navigate or show dialog
            }),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard("Orders", "128", Icons.shopping_cart),
                _buildStatCard("Users", "56", Icons.people),
              ],
            ),
            Card(
              margin: EdgeInsets.only(top: 30),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text("Log Out"),
                onTap: () {
                  // Handle admin logout
                },
              ),
            )
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
