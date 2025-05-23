import 'package:client/components/my_drawer_tile.dart';
import 'package:client/pages/about_page.dart';
import 'package:client/pages/admin_login_page.dart';
import 'package:client/pages/login_page.dart';
import 'package:client/pages/setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/admin_page.dart';
import '../pages/help_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Icon(
              Icons.lock_open_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(color: Theme.of(context).colorScheme.secondary),
          ),
          MyDrawerTile(
            text: 'H O M E',
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),
          MyDrawerTile(
            text: 'A D M I N',
            icon: Icons.admin_panel_settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminLoginPage()),
              );
            },
          ),
          MyDrawerTile(
            text: 'H E L P',
            icon: Icons.help_outline,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
          ),
          MyDrawerTile(
            text: 'A B O U T',
            icon: Icons.info_outline,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),

          MyDrawerTile(
            text: 'S E T T I N G',
            icon: Icons.settings,
            onTap:
                () => {
              Navigator.pop(context),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingPage(),
                ),
              ),
            },
          ),
          const Spacer(),
          MyDrawerTile(
            text: 'L O G O U T ',
            icon: Icons.logout,
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('loggedIn', false);
               prefs.remove('userId');

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) =>
                    false, // this removes all previous routes
              );
            },
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
