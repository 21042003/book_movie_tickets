
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final FirebaseFirestore _firestore;

  BookingRepository(this._firestore);

  Future<void> saveBooking(BookingModel booking) async {
    try {
      await _firestore.collection('bookings').add(booking.toMap());
    } catch (e) {
      throw Exception('Failed to save booking: $e');
    }
  }

  Stream<List<BookingModel>> getUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}

final bookingRepositoryProvider = Provider((ref) {
  return BookingRepository(FirebaseFirestore.instance);
});

final userBookingsProvider = StreamProvider.family<List<BookingModel>, String>((ref, userId) {
  return ref.watch(bookingRepositoryProvider).getUserBookings(userId);
});
