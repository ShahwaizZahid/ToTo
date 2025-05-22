import 'package:flutter/material.dart';

class MyUserTile extends StatelessWidget {
  final String email;
  final String password;
  final VoidCallback? onDelete;

  const MyUserTile({
    super.key,
    required this.email,
    required this.password,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Card(
      color: Theme.of(context).colorScheme.background,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),side: BorderSide(
      color: Theme.of(context).colorScheme.inversePrimary, // 👈 Border color
      width: 1.5,               // 👈 Border width
    )),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: color.primary,
          radius: 24,
          child: Text(
            email[0].toUpperCase(),
            style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          email,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Theme.of(context).colorScheme.inversePrimary
          ),
        ),
        subtitle: Text(
          password,
          style: TextStyle(
            fontSize: 14,
              color: Theme.of(context).colorScheme.inversePrimary,
            fontStyle: FontStyle.italic,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: onDelete,
          tooltip: 'Delete user',
        ),
      ),
    );
  }
}
