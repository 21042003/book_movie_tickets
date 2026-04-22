import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class NavigationBack extends StatelessWidget {
  const NavigationBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.hex000000.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Icon(Icons.arrow_back, color: AppColors.hexF2F2F2, size: 24),
        ),
      ),
    );
  }
}
