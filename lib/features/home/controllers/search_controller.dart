import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/Api_service/movie_service.dart';
import '../models/movie_model.dart';
import '../../../../core/localization/language_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchMoviesProvider = FutureProvider<List<MovieModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];

  // Thêm debounce nhẹ để tránh gọi API quá nhiều
  await Future.delayed(const Duration(milliseconds: 500));
  if (query != ref.read(searchQueryProvider)) {
     throw Exception('Cancelled');
  }

  final movieService = ref.watch(movieServiceProvider);
  final genreMap = await ref.watch(genreMapProvider.future);
  final lang = ref.watch(languageProvider).tmdbLanguage;

  return movieService.searchMovies(query, genreMap, language: lang);
});
