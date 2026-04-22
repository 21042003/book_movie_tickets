import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.hexF2F2F2,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
