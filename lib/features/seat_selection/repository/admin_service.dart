import 'package:cloud_firestore/cloud_firestore.dart';

class AdminMovieService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo một suất chiếu mới với SeatMap tự động
  Future<void> createShowtime({
    required int movieId,
    required String movieTitle,
    required String cinemaId,
    required String roomId,
    required DateTime startTime,
    required int durationMinutes,
    int rows = 8,
    int cols = 12,
  }) async {
    // 1. Tạo sơ đồ ghế trống (trạng thái 0)
    final Map<String, int> initialSeatMap = {};
    final rowLabels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K'];

    for (int i = 0; i < rows; i++) {
      for (int j = 1; j <= cols; j++) {
        final label = "${rowLabels[i]}$j";
        initialSeatMap[label] = 0; // Mặc định là Trống
      }
    }

    final endTime = startTime.add(Duration(minutes: durationMinutes));

    // 2. Lưu lên Firestore
    await _firestore.collection('showtimes').add({
      'movieId': movieId,
      'movieTitle': movieTitle,
      'cinemaId': cinemaId,
      'roomId': roomId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'seatMap': initialSeatMap,
    });
  }
}
