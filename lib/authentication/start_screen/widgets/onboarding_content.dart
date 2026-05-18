import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_image.dart';
import '../../../core/localization/language_provider.dart';

class OnboardingContent extends ConsumerWidget {
  const OnboardingContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(translationsProvider);

    return Column(
      children: [
        // Image Container
        Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: const DecorationImage(
              image: NetworkImage(
                AppImage.avatar,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 40),
        Text(
          tr.onboardingTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          tr.onboardingSubTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 24),
        // Page Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white30,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.hexFCC434,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white30,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
