import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ProfileSwitchItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ProfileSwitchItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87;

    return ListTile(
      leading: Icon(icon, color: color, size: 28),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.hexFCC434,
        activeTrackColor: AppColors.hexFCC434.withOpacity(0.3),
        inactiveThumbColor: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}
