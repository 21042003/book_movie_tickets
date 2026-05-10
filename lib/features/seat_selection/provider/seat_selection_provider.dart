import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/seat_model.dart';
import '../model/seat_status.dart';
import '../model/firestore_models.dart';
import '../repository/showtime_repository.dart';

class SeatSelectionState {
  final List<Seat> seats;
  final double ticketPrice;

  SeatSelectionState({
    required this.seats,
    this.ticketPrice = 105000.0,
  });

  int get selectedCount =>
      seats.where((seat) => seat.status == SeatStatus.selected).length;

  double get totalAmount => selectedCount * ticketPrice;

  SeatSelectionState copyWith({
    List<Seat>? seats,
  }) {
    return SeatSelectionState(
      seats: seats ?? this.seats,
      ticketPrice: ticketPrice,
    );
  }
}

class SeatSelectionNotifier extends StateNotifier<SeatSelectionState> {
  SeatSelectionNotifier() : super(SeatSelectionState(seats: []));

  // Cập nhật state từ Firestore ShowtimeModel
  void updateFromFirestore(Map<String, int> seatMap) {
    final List<Seat> updatedSeats = [];
    final rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J'];
    
    // Giữ lại các ghế đang được chọn local (nếu chúng vẫn còn trống trên server)
    final localSelected = state.seats
        .where((s) => s.status == SeatStatus.selected)
        .map((s) => s.label)
        .toSet();

    for (var row in rows) {
      for (var col = 2; col <= 13; col++) {
        final label = "$row$col";
        final statusInt = seatMap[label] ?? 0;
        
        SeatStatus status;
        if (statusInt == 2) {
          status = SeatStatus.Reserved;
        } else if (localSelected.contains(label)) {
          status = SeatStatus.selected;
        } else {
          status = SeatStatus.available;
        }
        
        updatedSeats.add(Seat(row: row, column: col, status: status));
      }
    }
    state = state.copyWith(seats: updatedSeats);
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
}

final seatSelectionProvider =
    StateNotifierProvider<SeatSelectionNotifier, SeatSelectionState>((ref) {
  return SeatSelectionNotifier();
});

// Stream provider để lắng nghe sự thay đổi ghế từ Firebase
final firestoreShowtimeProvider = StreamProvider.family<Map<String, int>, String>((ref, showtimeId) {
  final repository = ref.watch(showtimeRepositoryProvider);
  return repository.watchShowtime(showtimeId).map((st) => st.seatMap);
});

// Stream provider để lấy toàn bộ thông tin suất chiếu
final firestoreShowtimeFullProvider = StreamProvider.family<ShowtimeFirestoreModel, String>((ref, showtimeId) {
  final repository = ref.watch(showtimeRepositoryProvider);
  return repository.watchShowtime(showtimeId);
});
