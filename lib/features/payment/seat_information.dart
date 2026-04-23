import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class SeatInformation extends StatelessWidget {
  const SeatInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _seatText('Available', 'A1'),
        _seatText('Reserved', 'A2'),
      ]),
    );
  }
}

Widget _seatText(String text, String label) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.hexF2F2F2,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.hexF2F2F2,
        ),
      ),
    ],
  );
}
