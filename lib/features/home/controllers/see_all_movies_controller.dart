import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/language_provider.dart';
import '../models/Api_service/movie_service.dart';
import '../models/movie_model.dart';

enum MovieCategoryType { nowPlaying, comingSoon }

final selectedCategoryProvider = StateProvider<MovieCategoryType>((ref) {
  return MovieCategoryType.nowPlaying;
});

class MovieListState {
  final List<MovieModel> movies;
  final int page;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;

  MovieListState({
    required this.movies,
    required this.page,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    this.error,
  });

  factory MovieListState.initial() => MovieListState(
        movies: [],
        page: 0,
        isLoading: false,
        isLoadingMore: false,
        hasMore: true,
      );

  MovieListState copyWith({
    List<MovieModel>? movies,
    int? page,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
  }) {
    return MovieListState(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

class MovieListNotifier extends StateNotifier<MovieListState> {
  final Ref ref;
  MovieListNotifier(this.ref) : super(MovieListState.initial()) {
    // Tự động load trang đầu khi khởi tạo
    fetchMovies();
  }

  Future<void> fetchMovies({bool isRefresh = false}) async {
    if (state.isLoading || state.isLoadingMore) return;

    if (isRefresh) {
      state = MovieListState.initial().copyWith(isLoading: true);
    } else {
      if (!state.hasMore) return;
      state = state.copyWith(isLoading: state.page == 0, isLoadingMore: state.page > 0);
    }

    try {
      final category = ref.read(selectedCategoryProvider);
      final movieService = ref.read(movieServiceProvider);
      final genreMap = await ref.read(genreMapProvider.future);
      final lang = ref.read(languageProvider).tmdbLanguage;
      
      final type = category == MovieCategoryType.nowPlaying ? 'now_playing' : 'upcoming';
      final nextPage = state.page + 1;
      
      final newMovies = await movieService.fetchMovies(
        type, 
        genreMap, 
        page: nextPage, 
        language: lang
      );

      if (newMovies.isEmpty) {
        state = state.copyWith(hasMore: false, isLoading: false, isLoadingMore: false);
      } else {
        state = state.copyWith(
          movies: isRefresh ? newMovies : [...state.movies, ...newMovies],
          page: nextPage,
          isLoading: false,
          isLoadingMore: false,
          hasMore: newMovies.length >= 20, // TMDB trả về 20 phim mỗi trang
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        isLoadingMore: false, 
        error: e.toString()
      );
    }
  }

  void reset() {
    state = MovieListState.initial();
    fetchMovies();
  }
}

final movieListNotifierProvider = StateNotifierProvider<MovieListNotifier, MovieListState>((ref) {
  final notifier = MovieListNotifier(ref);
  // Lắng nghe category thay đổi để reset danh sách
  ref.listen(selectedCategoryProvider, (previous, next) {
    if (previous != next) {
      notifier.reset();
    }
  });
  return notifier;
});
