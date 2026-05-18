import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87;

    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(icon, color: color, size: 28),
          title: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(Icons.chevron_right, color: color.withOpacity(0.7)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Divider(color: color.withOpacity(0.1), height: 1),
        ),
      ],
    );
  }
}
