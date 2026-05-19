import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../../core/localization/language_provider.dart';
import '../genres_model.dart';
import '../movie_model.dart';

class MovieService {
  final String _apiKey = '1bbfbf7cb6f93cb26ae1c3e1adfb93ec';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  ///API lay the loai phim
  Future<Map<int, GenresModel>> fetchGenreMap({String language = 'vi-VN'}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/genre/movie/list?api_key=$_apiKey&language=$language'),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['genres'];
      return {for (var item in data) item['id']: GenresModel.fromJson(item)};
    }
    throw Exception('Failed to load genres');
  }

  /// Tối ưu: Lấy danh sách phim mà KHÔNG gọi fetchMovieDetail cho từng phim
  Future<List<MovieModel>> fetchMovies(
    String type,
    Map<int, GenresModel> genreMap, {
    int page = 1,
    String language = 'vi-VN',
  }) async {
    // Thêm region=VN để lấy lịch chiếu chuẩn tại Việt Nam
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$type?api_key=$_apiKey&language=$language&page=$page&region=VN'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List results = data['results'];
      
      return results.map((m) {
        final List<int> genreIds = List<int>.from(m['genre_ids'] ?? []);
        final movieGenres = genreIds
            .where((id) => genreMap.containsKey(id))
            .map((id) => genreMap[id]!)
            .toList();

        return MovieModel.fromListJson(m, movieGenres);
      }).toList();
    }
    throw Exception('Failed to load movies');
  }

  Future<MovieModel> fetchMovieDetail(int movieId, {String language = 'vi-VN'}) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/$movieId?api_key=$_apiKey&language=$language',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return MovieModel.fromJson(data);
    } else {
      throw Exception('Failed to load movie detail');
    }
  }

  Future<List<MovieModel>> searchMovies(String query, Map<int, GenresModel> genreMap, {String language = 'vi-VN'}) async {
    if (query.isEmpty) return [];
    
    final url = Uri.parse(
      '$_baseUrl/search/movie?api_key=$_apiKey&language=$language&query=${Uri.encodeComponent(query)}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List results = json.decode(response.body)['results'];
      
      return results.map((m) {
        final List<int> genreIds = List<int>.from(m['genre_ids'] ?? []);
        final movieGenres = genreIds
            .where((id) => genreMap.containsKey(id))
            .map((id) => genreMap[id]!)
            .toList();

        return MovieModel.fromListJson(m, movieGenres);
      }).toList();
    }
    throw Exception('Failed to search movies');
  }

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

final movieServiceProvider = Provider((ref) => MovieService());

final genreMapProvider = FutureProvider<Map<int, GenresModel>>((ref) async {
  final lang = ref.watch(languageProvider).tmdbLanguage;
  return ref.watch(movieServiceProvider).fetchGenreMap(language: lang);
});

final popularMoviesProvider = FutureProvider<List<MovieModel>>((ref) async {
  final genreMap = await ref.watch(genreMapProvider.future);
  final movieService = ref.watch(movieServiceProvider);
  final lang = ref.watch(languageProvider).tmdbLanguage;

  final results = await Future.wait([
    movieService.fetchMovies('now_playing', genreMap, page: 1, language: lang),
    movieService.fetchMovies('now_playing', genreMap, page: 2, language: lang),
  ]);
  return results.expand((list) => list).toList();
});

final upcomingMoviesProvider = FutureProvider<List<MovieModel>>((ref) async {
  final genreMap = await ref.watch(genreMapProvider.future);
  final movieService = ref.watch(movieServiceProvider);
  final lang = ref.watch(languageProvider).tmdbLanguage;
  
  final results = await Future.wait([
    movieService.fetchMovies('upcoming', genreMap, page: 1, language: lang),
    movieService.fetchMovies('upcoming', genreMap, page: 2, language: lang),
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
  final lang = ref.watch(languageProvider).tmdbLanguage;
  return ref.watch(movieServiceProvider).fetchMovieDetail(movieId, language: lang);
});

final movieTrailerProvider = FutureProvider.family<String?, int>((
  ref,
  movieId,
) async {
  return ref.watch(movieServiceProvider).fetchMovieTrailer(movieId);
});
