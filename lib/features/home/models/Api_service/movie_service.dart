import 'dart:convert';

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

  /// Ham dung chung de lay danh sach phim theo Type
  Future<List<MovieModel>> fetchMovies(
    String type,
    Map<int, GenresModel> genreMap,
  ) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$type?api_key=$_apiKey&language=vi-VN'),
    );

    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      return results.map((m) {
        final genreIds = List<int>.from(m['genre_ids'] ?? []);
        final movieGenres = genreIds
            .map((id) => genreMap[id] ?? GenresModel(id: 0, name: 'null'))
            .toList();
        m['genres'] = movieGenres.map((g) => g.toJson()).toList();
        return MovieModel.fromJson(m);
      }).toList();
    }
    throw Exception('Failed to load genres');
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
  return ref.watch(movieServiceProvider).fetchMovies('popular', genreMap);
});

final upcomingMoviesProvider = FutureProvider<List<MovieModel>>((ref) async {
  final genreMap = await ref.watch(genreMapProvider.future);
  return ref.watch(movieServiceProvider).fetchMovies('upcoming', genreMap);
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

