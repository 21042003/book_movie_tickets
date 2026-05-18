
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_provider.dart';

class SearchBarWidget extends ConsumerWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(translationsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: TextField(
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.hex1C1C1C,
          hintText: tr.search,
          hintStyle: const TextStyle(color: AppColors.hex8C8C8C),
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
