import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String? id; // Firebase document ID
  final String userId;
  final int movieId;
  final String movieTitle;
  final String moviePoster;
  final String cinemaName;
  final String cinemaAddress;
  final String bookingDate; 
  final String bookingTime;
  final List<String> seats;
  final double totalAmount;
  final String paymentMethod;
  final String orderId;
  final DateTime createdAt;
  final String status;

  BookingModel({
    this.id,
    required this.userId,
    required this.movieId,
    required this.movieTitle,
    required this.moviePoster,
    required this.cinemaName,
    required this.cinemaAddress,
    required this.bookingDate,
    required this.bookingTime,
    required this.seats,
    required this.totalAmount,
    required this.paymentMethod,
    required this.orderId,
    required this.createdAt,
    this.status = 'completed',
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'movieId': movieId,
      'movieTitle': movieTitle,
      'moviePoster': moviePoster,
      'cinemaName': cinemaName,
      'cinemaAddress': cinemaAddress,
      'bookingDate': bookingDate,
      'bookingTime': bookingTime,
      'seats': seats,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'orderId': orderId,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.parse(value);
      return DateTime.now();
    }

    return BookingModel(
      id: id,
      userId: map['userId'] ?? '',
      movieId: map['movieId'] ?? 0,
      movieTitle: map['movieTitle'] ?? '',
      moviePoster: map['moviePoster'] ?? '',
      cinemaName: map['cinemaName'] ?? '',
      cinemaAddress: map['cinemaAddress'] ?? '',
      bookingDate: map['bookingDate'] ?? '',
      bookingTime: map['bookingTime'] ?? '',
      seats: List<String>.from(map['seats'] ?? []),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      paymentMethod: map['paymentMethod'] ?? '',
      orderId: map['orderId'] ?? '',
      createdAt: parseDate(map['createdAt']),
      status: map['status'] ?? 'completed',
    );
  }
}
