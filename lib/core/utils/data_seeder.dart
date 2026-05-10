import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/home/models/Api_service/movie_service.dart';
import '../../features/home/models/genres_model.dart';

class DataSeeder {
  static Future<void> seedInitialData() async {
    final firestore = FirebaseFirestore.instance;
    
    // KIỂM TRA: Nếu đã có dữ liệu rạp HOẶC suất chiếu thì không chạy nữa để tránh lặp dữ liệu
    final existingCinemas = await firestore.collection('cinemas').limit(1).get();
    final existingShowtimes = await firestore.collection('showtimes').limit(1).get();
    
    if (existingCinemas.docs.isNotEmpty && existingShowtimes.docs.isNotEmpty) {
      print("ℹ️ Dữ liệu đã tồn tại. Bỏ qua bước khởi tạo.");
      return;
    }

    final movieService = MovieService();
    print("🚀 Đang khởi tạo dữ liệu mẫu từ API thực tế...");

    // 1. Tạo dữ liệu Rạp (Cinemas)
    final cinemas = [
      {
        'id': 'cgv_ba_trieu',
        'name': 'CGV Vincom Bà Triệu',
        'address': '191 Bà Triệu, Hai Bà Trưng, Hà Nội',
      },
      {
        'id': 'cgv_ocean_park',
        'name': 'CGV Vincom Ocean Park',
        'address': 'Đa Tốn, Gia Lâm, Hà Nội',
      },
      {
        'id': 'cgv_long_bien',
        'name': 'Aeon Mall CGV Long Biên',
        'address': '27 Cổ Linh, Long Biên, Hà Nội',
      }
    ];

    for (var cinema in cinemas) {
      await firestore.collection('cinemas').doc(cinema['id']).set(cinema);
    }

    // 2. Lấy danh sách phim thực tế từ API để gán Suất chiếu
    try {
      final Map<int, GenresModel> genreMap = await movieService.fetchGenreMap();
      final nowPlayingMovies = await movieService.fetchMovies('now_playing', genreMap);
      final upcomingMovies = await movieService.fetchMovies('upcoming', genreMap);

      final allMovies = [...nowPlayingMovies, ...upcomingMovies];
      
      if (allMovies.isEmpty) return;

      print("📦 Đã lấy được ${allMovies.length} phim từ API. Bắt đầu tạo suất chiếu...");

      for (var movie in allMovies) {
        await createSampleShowtimesForMovie(movie.id, movie.title);
      }

      print("✅ Đã khởi tạo dữ liệu thành công!");
    } catch (e) {
      print("❌ Lỗi: $e");
    }
  }

  static Future<void> createSampleShowtimesForMovie(int movieId, String movieTitle) async {
    final firestore = FirebaseFirestore.instance;
    final cinemaList = [
      {
        'id': 'cgv_ba_trieu',
        'name': 'CGV Vincom Bà Triệu',
        'address': '191 Bà Triệu, Hai Bà Trưng, Hà Nội'
      },
      {
        'id': 'cgv_ocean_park',
        'name': 'CGV Vincom Ocean Park',
        'address': 'Đa Tốn, Gia Lâm, Hà Nội'
      },
      {
        'id': 'cgv_long_bien',
        'name': 'Aeon Mall CGV Long Biên',
        'address': '27 Cổ Linh, Long Biên, Hà Nội'
      },
    ];

    final rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J'];
    final Map<String, int> seatMap = {};
    for (var row in rows) {
      for (var col = 2; col <= 13; col++) {
        seatMap['$row$col'] = 0; 
      }
    }

    for (var cinema in cinemaList) {
      for (int i = 0; i < 2; i++) {
        final startTime = DateTime.now().add(Duration(days: i, hours: 10 + (i * 4)));
        await firestore.collection('showtimes').add({
          'movieId': movieId,
          'movieTitle': movieTitle,
          'cinemaId': cinema['id'],
          'cinemaName': cinema['name'],
          'cinemaAddress': cinema['address'],
          'roomId': 'room_0${i + 1}',
          'startTime': Timestamp.fromDate(startTime),
          'endTime': Timestamp.fromDate(startTime.add(const Duration(minutes: 130))),
          'seatMap': seatMap,
        });
      }
    }
  }
}
