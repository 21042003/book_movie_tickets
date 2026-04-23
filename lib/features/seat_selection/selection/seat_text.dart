import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../model/seat_model.dart';
import '../model/seat_status.dart';

class SeatWidget extends StatelessWidget {
  final Seat seat;
  final VoidCallback onTap;

  const SeatWidget({
    super.key,
    required this.seat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: seat.status == SeatStatus.Reserved ? null : onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: seat.status.color,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          seat.label,
          style: TextStyle(
            color: seat.status == SeatStatus.selected
                ? AppColors.hex000000
                : (seat.status == SeatStatus.Reserved 
                    ? AppColors.hexFCC434.withOpacity(0.5) 
                    : AppColors.hex8C8C8C),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
