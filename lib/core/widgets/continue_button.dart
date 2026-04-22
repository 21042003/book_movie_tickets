import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
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
