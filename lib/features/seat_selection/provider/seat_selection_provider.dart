import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/seat_model.dart';
import '../model/seat_status.dart';

class SeatSelectionState {
  final List<Seat> seats;
  final DateTime selectedDate;
  final String selectedTime;
  final double ticketPrice;

  SeatSelectionState({
    required this.seats,
    required this.selectedDate,
    required this.selectedTime,
    this.ticketPrice = 105000.0,
  });

  int get selectedCount =>
      seats.where((seat) => seat.status == SeatStatus.selected).length;

  double get totalAmount => selectedCount * ticketPrice;

  SeatSelectionState copyWith({
    List<Seat>? seats,
    DateTime? selectedDate,
    String? selectedTime,
  }) {
    return SeatSelectionState(
      seats: seats ?? this.seats,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      ticketPrice: ticketPrice,
    );
  }
}

class SeatSelectionNotifier extends StateNotifier<SeatSelectionState> {
  SeatSelectionNotifier() : super(_initialState());

  static SeatSelectionState _initialState() {
    final List<Seat> initialSeats = [];
    final rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J'];
    
    for (var row in rows) {
      for (var col = 2; col <= 13; col++) {
        SeatStatus status = SeatStatus.available;
        
        // Mock data based on requirements
        if (row == 'D' && col >= 6 && col <= 10) {
          status = SeatStatus.Reserved;
        } else if (row == 'E' && col >= 4 && col <= 12) {
          status = SeatStatus.Reserved;
        } else if (row == 'F' && col >= 7 && col <= 10) {
          status = SeatStatus.selected;
        } else if (row == 'H' && col >= 7 && col <= 8) {
          status = SeatStatus.selected;
        } else if (row == 'J' && col == 5) {
          status = SeatStatus.Reserved; // Based on image
        }

        initialSeats.add(Seat(row: row, column: col, status: status));
      }
    }

    return SeatSelectionState(
      seats: initialSeats,
      selectedDate: DateTime(2023, 12, 10),
      selectedTime: "14:15",
    );
  }

  void toggleSeat(String label) {
    state = state.copyWith(
      seats: state.seats.map((seat) {
        if (seat.label == label) {
          if (seat.status == SeatStatus.available) {
            return seat.copyWith(status: SeatStatus.selected);
          } else if (seat.status == SeatStatus.selected) {
            return seat.copyWith(status: SeatStatus.available);
          }
        }
        return seat;
      }).toList(),
    );
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void selectTime(String time) {
    state = state.copyWith(selectedTime: time);
  }
}

final seatSelectionProvider =
    StateNotifierProvider<SeatSelectionNotifier, SeatSelectionState>((ref) {
  return SeatSelectionNotifier();
});
