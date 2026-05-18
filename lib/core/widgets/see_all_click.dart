import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../localization/language_provider.dart';

class SeeAllClick extends ConsumerWidget {
  final VoidCallback onTap;
  final String title;

  const SeeAllClick({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(translationsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              color: isDark ? AppColors.hexF2F2F2 : Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  tr.seeAll,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.hexFCC434,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Icon(
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
