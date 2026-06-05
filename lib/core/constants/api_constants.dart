class ApiConstants {
  static const String tmdbApiKey = '1bbfbf7cb6f93cb26ae1c3e1adfb93ec';
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';

  static String movieUrl(String type) => '$tmdbBaseUrl/movie/$type';
  static String genreListUrl() => '$tmdbBaseUrl/genre/movie/list';
  static String searchMovieUrl() => '$tmdbBaseUrl/search/movie';
  static String movieVideoUrl(int movieId) => '$tmdbBaseUrl/movie/$movieId/videos';
  
  static String posterUrl(String path, {String size = 'w500'}) => '$tmdbImageBaseUrl/$size$path';
}
