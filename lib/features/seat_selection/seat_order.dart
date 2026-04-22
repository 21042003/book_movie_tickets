import 'package:flutter/material.dart';

import 'model/seat_status.dart';

class CinemaBooking extends StatefulWidget {
  const CinemaBooking({super.key});

  @override
  State<CinemaBooking> createState() => _CinemaBookingState();
}

class _CinemaBookingState extends State<CinemaBooking> {
  late List<SeatStatus> seatStates;

  @override
  void initState() {
    super.initState();
    seatStates = List.generate(108, (index) => SeatStatus.available);

    seatStates[10] = SeatStatus.Reserved;
    seatStates[11] = SeatStatus.Reserved;
    seatStates[25] = SeatStatus.Reserved;
  }

  void _toggleSeat(int index) {
    setState(() {
      if (seatStates[index] == SeatStatus.Reserved) return;
      if (seatStates[index] == SeatStatus.available) {
        seatStates[index] = SeatStatus.selected;
      } else if (seatStates[index] == SeatStatus.selected) {
        seatStates[index] = SeatStatus.available;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 108,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 12,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final currentStatus = seatStates[index];
        return GestureDetector(
          onTap: () => _toggleSeat(index),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: currentStatus.color,
              borderRadius: BorderRadius.circular(4),
              border: currentStatus == SeatStatus.selected
                  ? Border.all(color: Colors.white, width: 1)
                  : null,
            ),
            child:
            Text(
              getSeatName(index),
              style: TextStyle(
                fontSize: 12,
                color: currentStatus == SeatStatus.selected
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  String getSeatName(int index) {
    // Giả sử mỗi hàng có 8 ghế
    int rowNumber = index ~/ 12;
    int columnNumber = (index % 12) + 2;

    // Chuyển số hàng thành chữ cái (0 -> A, 1 -> B, 2 -> C...)
    String rowLetter = String.fromCharCode(65 + rowNumber);

    return "$rowLetter$columnNumber";
  }
}
