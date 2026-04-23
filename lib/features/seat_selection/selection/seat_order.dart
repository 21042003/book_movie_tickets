import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../provider/seat_selection_provider.dart';

class SeatOrderBottomBar extends ConsumerWidget {
  const SeatOrderBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(seatSelectionProvider);
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(color: AppColors.hex8C8C8C, fontSize: 14),
                ),
                Text(
                  currencyFormat.format(state.totalAmount),
                  style: const TextStyle(
                    color: AppColors.hexFCC434,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: state.selectedCount == 0
                  ? null
                  : () {
                      // Handle booking logic
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.hexFCC434,
                foregroundColor: Colors.black,
                disabledBackgroundColor: AppColors.hex3B3B3B,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "But ticket", // Matching user's typo "But ticket" in screenshot
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
