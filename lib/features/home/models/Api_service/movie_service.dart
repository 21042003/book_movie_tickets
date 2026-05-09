import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../genres_model.dart';
import '../movie_model.dart';

class MovieService {
  final String _apiKey = '1bbfbf7cb6f93cb26ae1c3e1adfb93ec';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  ///API lay the loai phim
  Future<Map<int, GenresModel>> fetchGenreMap() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/genre/movie/list?api_key=$_apiKey&language=vi-VN'),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['genres'];
      return {for (var item in data) item['id']: GenresModel.fromJson(item)};
    }
    throw Exception('Failed to load genres');
  }

  /// Ham dung chung de lay danh sach phim theo Type và lấy kèm Runtime
  Future<List<MovieModel>> fetchMovies(
    String type,
    Map<int, GenresModel> genreMap, {
    int page = 1,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$type?api_key=$_apiKey&language=vi-VN&page=$page'),
    );

    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      
      final List<int> movieIds = results.map((m) => m['id'] as int).toList();

      // Sử dụng Future.wait nhưng bọc try-catch cho từng phim để tránh crash cả list
      final List<MovieModel?> detailedMovies = await Future.wait(
        movieIds.map((id) async {
          try {
            return await fetchMovieDetail(id);
          } catch (e) {
            debugPrint('Error fetching movie detail for ID $id: $e');
            return null; // Trả về null nếu phim này bị lỗi dữ liệu
          }
        })
      );

      // Lọc bỏ các phim bị null (lỗi)
      return detailedMovies.whereType<MovieModel>().toList();
    }
    throw Exception('Failed to load movies');
  }

  Future<MovieModel> fetchMovieDetail(int movieId) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/$movieId?api_key=$_apiKey&language=vi-VN',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MovieModel.fromJson(data);
    } else {
      throw Exception('Failed to load movie detail');
    }
  }

  ///Trong class MovieService
  Future<String?> fetchMovieTrailer(int movieId) async {
    final url = Uri.parse('$_baseUrl/movie/$movieId/videos?api_key=$_apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      final trailer = results.firstWhere(
        (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        orElse: () => null,
      );
      return trailer != null ? trailer['key'] : null;
    }
    return null;
  }
}

/// Khoi tao service
final movieServiceProvider = Provider((ref) => MovieService());

/// Provider luu tru genre Map
final genreMapProvider = FutureProvider<Map<int, GenresModel>>((ref) async {
  return ref.watch(movieServiceProvider).fetchGenreMap();
});

///Lay danh sach phim pho bien
final popularMoviesProvider = FutureProvider<List<MovieModel>>((ref) async {
  final genreMap = await ref.watch(genreMapProvider.future);
  final movieService = ref.watch(movieServiceProvider);
  // Lấy 2 trang để dữ liệu phong phú
  final results = await Future.wait([
    movieService.fetchMovies('now_playing', genreMap, page: 1),
    movieService.fetchMovies('now_playing', genreMap, page: 2),
  ]);
  return results.expand((list) => list).toList();
});

final upcomingMoviesProvider = FutureProvider<List<MovieModel>>((ref) async {
  final genreMap = await ref.watch(genreMapProvider.future);
  final movieService = ref.watch(movieServiceProvider);
  
  // Tải 2 trang đầu để đảm bảo có đủ phim sau khi lọc
  final results = await Future.wait([
    movieService.fetchMovies('upcoming', genreMap, page: 1),
    movieService.fetchMovies('upcoming', genreMap, page: 2),
  ]);
  
  final allMovies = results.expand((list) => list).toList();
  final now = DateTime.now();
  
  final filteredMovies = allMovies.where((movie) {
    if (movie.releaseDate.isEmpty) return false;
    try {
      final releaseDate = DateTime.parse(movie.releaseDate);
      return releaseDate.isAfter(now.subtract(const Duration(days: 1)));
    } catch (e) {
      return false;
    }
  }).toList();

  filteredMovies.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
  return filteredMovies;
});

final movieDetailProvider = FutureProvider.family<MovieModel, int>((
  ref,
  movieId,
) async {
  return ref.watch(movieServiceProvider).fetchMovieDetail(movieId);
});

/// Provider lấy YouTube Key của Trailer
final movieTrailerProvider = FutureProvider.family<String?, int>((
  ref,
  movieId,
) async {
  return ref.watch(movieServiceProvider).fetchMovieTrailer(movieId);
});

