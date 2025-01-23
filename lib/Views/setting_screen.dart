import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/Utils/constants.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Iconsax.user, color: kprimaryColor),
            title: const Text("Edit Profile"),
            onTap: () {
              // Navigate to edit profile
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Iconsax.lock, color: kprimaryColor),
            title: const Text("Change Password"),
            onTap: () {
              // Navigate to change password
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Iconsax.notification, color: kprimaryColor),
            title: const Text("Notifications"),
            onTap: () {
              // Navigate to notifications
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Iconsax.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}
