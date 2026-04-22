import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class SeeAllClick extends StatelessWidget {
  final VoidCallback onTap;
  final String title;

  const SeeAllClick({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.hexF2F2F2,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.hexFCC434,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right_sharp,
                  size: 20,
                  color: AppColors.hexFCC434,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
