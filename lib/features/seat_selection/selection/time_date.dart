import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../provider/seat_selection_provider.dart';

class TimeDateSelection extends ConsumerWidget {
  const TimeDateSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(seatSelectionProvider);
    final notifier = ref.read(seatSelectionProvider.notifier);

    return Column(
      children: [
        const Text(
          "Select Date & Time",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Date Selector
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: 14, // 2 weeks
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isSelected = state.selectedDate.day == date.day &&
                  state.selectedDate.month == date.month;

              return GestureDetector(
                onTap: () => notifier.selectDate(date),
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.hexFCC434 : AppColors.hex1C1C1C,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('MMM').format(date),
                        style: TextStyle(
                          color: isSelected ? Colors.black : AppColors.hex8C8C8C,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd').format(date),
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        // Time Selector
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: ["11:05", "14:15", "16:30", "20:10", "22:45"].map((time) {
              final isSelected = state.selectedTime == time;
              return GestureDetector(
                onTap: () => notifier.selectTime(time),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppColors.hexFCC434 : AppColors.hex3B3B3B,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: isSelected
                        ? AppColors.hexFCC434.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: isSelected ? AppColors.hexFCC434 : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
