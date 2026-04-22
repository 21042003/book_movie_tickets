import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: TextField(
        style: TextStyle(color: Colors.white, fontSize: 16),
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.hex1C1C1C,
          hintText: "Search",
          hintStyle: TextStyle(color: AppColors.hex8C8C8C),
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: AppColors.hexF2F2F2,
          iconColor: AppColors.hexF2F2F2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
