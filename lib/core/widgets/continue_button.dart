import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  
  const ContinueButton({
    super.key, 
    required this.onTap,
    this.text = 'Continue',
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onTap != null;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? AppColors.hexFCC434 : AppColors.hex3B3B3B,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64),
          ),
          disabledBackgroundColor: AppColors.hex3B3B3B,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isEnabled ? AppColors.hex000000 : Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
