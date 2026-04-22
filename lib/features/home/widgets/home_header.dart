import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_image.dart';

class HomeHeader extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, $userName 👋",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.hexF2F2F2,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.hex575757,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.hexFCC434,
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    location,
                    style: const TextStyle(
                      color: AppColors.hexF2F2F2,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onNotificationTap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_none),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onAvatarTap,
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(AppImage.avatar),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
