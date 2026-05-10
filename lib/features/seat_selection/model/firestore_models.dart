import 'package:cloud_firestore/cloud_firestore.dart';

class ShowtimeFirestoreModel {
  final String id;
  final int movieId;
  final String movieTitle;
  final String cinemaId;
  final String cinemaName; 
  final String cinemaAddress; // Thêm cinemaAddress
  final String roomId;
  final DateTime startTime;
  final DateTime endTime;
  final Map<String, int> seatMap; // 0: Available, 1: Selecting, 2: Sold

  ShowtimeFirestoreModel({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.cinemaId,
    required this.cinemaName,
    required this.cinemaAddress,
    required this.roomId,
    required this.startTime,
    required this.endTime,
    required this.seatMap,
  });

  Map<String, dynamic> toMap() {
    return {
      'movieId': movieId,
      'movieTitle': movieTitle,
      'cinemaId': cinemaId,
      'cinemaName': cinemaName,
      'cinemaAddress': cinemaAddress,
      'roomId': roomId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'seatMap': seatMap,
    };
  }

  factory ShowtimeFirestoreModel.fromMap(Map<String, dynamic> map, String id) {
    return ShowtimeFirestoreModel(
      id: id,
      movieId: map['movieId'] ?? 0,
      movieTitle: map['movieTitle'] ?? '',
      cinemaId: map['cinemaId'] ?? '',
      cinemaName: map['cinemaName'] ?? '',
      cinemaAddress: map['cinemaAddress'] ?? '',
      roomId: map['roomId'] ?? '',
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      seatMap: Map<String, int>.from(map['seatMap'] ?? {}),
    );
  }
}
