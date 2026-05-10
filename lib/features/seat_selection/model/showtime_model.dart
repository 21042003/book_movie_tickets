import 'package:cloud_firestore/cloud_firestore.dart';

class ShowtimeModel {
  final String id;
  final int movieId;
  final String movieTitle;
  final String cinemaId;
  final String cinemaName;
  final String roomId;
  final String roomName;
  final DateTime startTime;
  final DateTime endTime;
  final Map<String, int> seatMap; // "A1": 0 (Avail), 1 (Selecting), 2 (Sold)

  ShowtimeModel({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.cinemaId,
    required this.cinemaName,
    required this.roomId,
    required this.roomName,
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
      'roomId': roomId,
      'roomName': roomName,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'seatMap': seatMap,
    };
  }

  factory ShowtimeModel.fromMap(Map<String, dynamic> map, String id) {
    return ShowtimeModel(
      id: id,
      movieId: map['movieId'] ?? 0,
      movieTitle: map['movieTitle'] ?? '',
      cinemaId: map['cinemaId'] ?? '',
      cinemaName: map['cinemaName'] ?? '',
      roomId: map['roomId'] ?? '',
      roomName: map['roomName'] ?? '',
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      seatMap: Map<String, int>.from(map['seatMap'] ?? {}),
    );
  }
}
