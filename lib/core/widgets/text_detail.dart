import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class TextDetail extends StatelessWidget {
  final String title;

  const TextDetail({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.hexF2F2F2,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
