import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.background,
      appBar: AppBar(
        backgroundColor: color.background,
        iconTheme: IconThemeData(color: color.inversePrimary),
        title: Text('Help & Support',
            style: TextStyle(color: color.inversePrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Frequently Asked Questions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary
            ),
          ),
          const SizedBox(height: 10),
          _buildFAQ(context,"How do I place an order?",
              "Browse through the menu, add items to your cart, and proceed to checkout."),
          _buildFAQ(context,"Where can I track my delivery?",
              "Go to the 'Delivery in Process' page to view your current order status."),
          _buildFAQ(context,"Can I switch between light and dark mode?",
              "Yes! Go to the settings page and toggle the theme."),
          _buildFAQ(context,"How do I update my profile?",
              "Currently, profile updates are not supported. Coming soon!"),

          const SizedBox(height: 30),
          Text(
            "Still need help?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color.inversePrimary,
            ),
          ),
          const SizedBox(height: 10),

          ListTile(
            leading: Icon(Icons.email, color: color.primary),
            title: Text("Email Us", style: TextStyle(color: color.inversePrimary),),
            subtitle: Text("shahwaizmughal940@gmail.com", style: TextStyle(color: color.inversePrimary)),
          ),
          ListTile(
            leading: Icon(Icons.call, color: Colors.green),
            title: Text("Call Us", style: TextStyle(color: color.inversePrimary)),
            subtitle: Text("+92 3086654456", style: TextStyle(color: color.inversePrimary)),
          ),
          ListTile(
            leading: Icon(Icons.message, color: Colors.teal),
            title: Text("Chat on WhatsApp", style: TextStyle(color: color.inversePrimary)),
            subtitle: Text("+92 3086654456", style: TextStyle(color: color.inversePrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQ(BuildContext context, String title, String content) {
    final color = Theme.of(context).colorScheme.inversePrimary;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: color),
      child: ExpansionTile(
        leading: Icon(Icons.help_outline, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        iconColor: color,
        collapsedIconColor: color,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }


}
