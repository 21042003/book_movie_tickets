import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class SeatText extends StatefulWidget {
  const SeatText({super.key});

  @override
  State<SeatText> createState() => _SeatTextState();
}

class _SeatTextState extends State<SeatText> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isSelected = !isSelected;
                });
              },
              child: Container(
                width: 52.0,
                height: 104.0,
                margin: const EdgeInsets.symmetric(horizontal: 9.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: isSelected ? Colors.white : Colors.transparent),
                  color: isSelected ? AppColors.hexFCC434 : AppColors.hex1C1C1C,
                  borderRadius: BorderRadius.circular(37.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Dec",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: isSelected ? AppColors.hex1C1C1C : AppColors.hexF2F2F2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: isSelected ? Colors.white : Colors.transparent),
                        color: AppColors.hex3B3B3B,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '10',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
