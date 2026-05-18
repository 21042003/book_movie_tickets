import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_colors.dart';
import '../localization/language_provider.dart';

class CustomBottomNavBar extends ConsumerWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = ref.watch(translationsProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(
          top: BorderSide(color: Colors.white10, width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, FontAwesomeIcons.house, FontAwesomeIcons.house, tr.home),
          _buildNavItem(1, FontAwesomeIcons.ticket, FontAwesomeIcons.ticket, tr.ticket),
          _buildNavItem(2, FontAwesomeIcons.video, FontAwesomeIcons.video, tr.movie),
          _buildNavItem(3, FontAwesomeIcons.user, FontAwesomeIcons.user, tr.profile),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.hexFCC434.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: FaIcon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.hexFCC434 : Colors.white60,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.hexFCC434 : Colors.white60,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
