import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/Api_service/movie_service.dart';
import '../models/movie_model.dart';

enum MovieCategoryType { nowPlaying, comingSoon }

final selectedCategoryProvider = StateProvider<MovieCategoryType>((ref) {
  return MovieCategoryType.nowPlaying;
});

final movieListProvider = FutureProvider<List<MovieModel>>((ref) async {
  final category = ref.watch(selectedCategoryProvider);
  final movieService = ref.watch(movieServiceProvider);
  final genreMap = await ref.watch(genreMapProvider.future);

  switch (category) {
    case MovieCategoryType.nowPlaying:
      return movieService.fetchMovies('now_playing', genreMap);
    case MovieCategoryType.comingSoon:
      return movieService.fetchMovies('upcoming', genreMap);
  }
});
