import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback onTap;
  const ContinueButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.hexFCC434,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64),
          ),
        ),
        child: Text(
          'Continue',
          style: TextStyle(
            color: AppColors.hex000000,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
