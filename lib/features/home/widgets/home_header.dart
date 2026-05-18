import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/language_provider.dart';

class HomeHeader extends ConsumerWidget {
  final String userName;
  final String location;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.location,
    required this.onAvatarTap,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(translationsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${tr.hello}, $userName 👋",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.hex8C8C8C,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tr.welcomeBack,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                onPressed: onNotificationTap,
                icon: Icon(Icons.notifications, color: isDark ? Colors.white : Colors.black87, size: 30),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? Colors.black : Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
