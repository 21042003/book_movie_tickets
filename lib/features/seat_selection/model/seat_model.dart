import 'seat_status.dart';

class Seat {
  final String row;
  final int column;
  final SeatStatus status;

  Seat({
    required this.row,
    required this.column,
    required this.status,
  });

  String get label => '$row$column';

  Seat copyWith({
    String? row,
    int? column,
    SeatStatus? status,
  }) {
    return Seat(
      row: row ?? this.row,
      column: column ?? this.column,
      status: status ?? this.status,
    );
  }
}
