import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/firestore_models.dart';

class ShowtimeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. REAL-TIME STREAM: Lắng nghe trạng thái ghế theo thời gian thực
  Stream<ShowtimeFirestoreModel> watchShowtime(String showtimeId) {
    return _firestore
        .collection('showtimes')
        .doc(showtimeId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) throw Exception("Suất chiếu không tồn tại");
      return ShowtimeFirestoreModel.fromMap(snapshot.data()!, snapshot.id);
    });
  }

  // 2. TRANSACTION: Xử lý đặt vé (Chống tranh chấp ghế)
  Future<void> bookSeats({
    required String showtimeId,
    required List<String> seatLabels,
    required String userId,
    required double totalAmount,
    required String movieTitle,
    required String moviePoster,
    required String cinemaName,
    required String cinemaAddress,
    required String bookingDate,
    required String bookingTime,
    required String paymentMethod,
    required String orderId,
  }) async {
    final showtimeRef = _firestore.collection('showtimes').doc(showtimeId);
    final bookingRef = _firestore.collection('bookings').doc();

    return _firestore.runTransaction((transaction) async {
      // Đọc trạng thái ghế mới nhất từ server
      final snapshot = await transaction.get(showtimeRef);
      if (!snapshot.exists) throw Exception("Suất chiếu đã bị hủy");

      final data = snapshot.data()!;
      final seatMap = Map<String, int>.from(data['seatMap'] ?? {});

      // KIỂM TRA: Nếu có bất kỳ ghế nào không còn trống (khác 0) -> Hủy
      for (var label in seatLabels) {
        if (seatMap[label] != 0) {
          throw Exception("Ghế $label vừa mới được người khác đặt!");
        }
      }

      // CẬP NHẬT: Chuyển trạng thái các ghế sang Đã bán (2)
      for (var label in seatLabels) {
        seatMap[label] = 2;
      }

      // Ghi dữ liệu đồng thời (Atomic update)
      transaction.update(showtimeRef, {'seatMap': seatMap});
      transaction.set(bookingRef, {
        'userId': userId,
        'showtimeId': showtimeId,
        'movieId': data['movieId'],
        'movieTitle': movieTitle,
        'moviePoster': moviePoster,
        'cinemaName': cinemaName,
        'cinemaAddress': cinemaAddress,
        'bookingDate': bookingDate,
        'bookingTime': bookingTime,
        'seats': seatLabels,
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
        'orderId': orderId,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'completed'
      });
    });
  }

  // 3. OVERLAP CHECK: Kiểm tra trùng lịch khi thêm suất chiếu mới
  Future<bool> checkOverlap({
    required String roomId,
    required DateTime start,
    required int durationMinutes,
  }) async {
    final end = start.add(Duration(minutes: durationMinutes + 20)); // Buffer 20p

    final query = await _firestore
        .collection('showtimes')
        .where('roomId', isEqualTo: roomId)
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start.subtract(const Duration(hours: 4))))
        .get();

    for (var doc in query.docs) {
      final existingStart = (doc['startTime'] as Timestamp).toDate();
      final existingEnd = (doc['endTime'] as Timestamp).toDate();

      // Công thức: (StartA < EndB) && (EndA > StartB)
      if (start.isBefore(existingEnd) && end.isAfter(existingStart)) {
        return true; // Bị trùng lịch
      }
    }
    return false;
  }

  // 4. Lấy danh sách suất chiếu theo phim, rạp và ngày
  Future<List<ShowtimeFirestoreModel>> getShowtimesByMovieAndCinema({
    required int movieId,
    required String cinemaId,
    required DateTime date,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final querySnapshot = await _firestore
        .collection('showtimes')
        .where('movieId', isEqualTo: movieId)
        .where('cinemaId', isEqualTo: cinemaId)
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();

    return querySnapshot.docs
        .map((doc) => ShowtimeFirestoreModel.fromMap(doc.data(), doc.id))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }
  // 5. Lấy danh sách tất cả rạp
  Future<List<Map<String, dynamic>>> getAllCinemas() async {
    final querySnapshot = await _firestore.collection('cinemas').get();
    return querySnapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }
}

final showtimeRepositoryProvider = Provider((ref) => ShowtimeRepository());
