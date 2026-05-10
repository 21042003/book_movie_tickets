import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../seat_selection/model/firestore_models.dart';
import '../../seat_selection/repository/showtime_repository.dart';
import 'cinema_selection_provider.dart';

// Lưu trữ ID của suất chiếu được chọn
final selectedShowtimeIdProvider = StateProvider<String?>((ref) => null);

// Lưu trữ ngày được chọn để xem suất chiếu
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Provider lấy danh sách suất chiếu dựa trên Phim, Rạp và Ngày
final showtimesListProvider = FutureProvider.family<List<ShowtimeFirestoreModel>, int>((ref, movieId) async {
  final cinemaId = ref.watch(selectedCinemaProvider);
  final date = ref.watch(selectedDateProvider);
  
  if (cinemaId == null) return [];
  
  final repository = ref.watch(showtimeRepositoryProvider);
  return repository.getShowtimesByMovieAndCinema(
    movieId: movieId,
    cinemaId: cinemaId,
    date: date,
  );
});
