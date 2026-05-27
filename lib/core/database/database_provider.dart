import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/models/movie_model.dart';
import 'database_helper.dart';
import '../../features/payment/models/booking_model.dart';

final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

final bookingHistoryProvider = FutureProvider<List<BookingModel>>((ref) async {
  final dbHelper = ref.watch(databaseHelperProvider);
  return await dbHelper.getAllBookings();
});

final cachedMoviesProvider = FutureProvider<List<MovieModel>>((ref) async {
  final dbHelper = ref.watch(databaseHelperProvider);
  return await dbHelper.getCachedMovies();
});
