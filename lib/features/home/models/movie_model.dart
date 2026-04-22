
import 'package:book_movie_tickets/features/home/models/production_company.dart';
import 'package:book_movie_tickets/features/home/models/production_country.dart';
import 'package:book_movie_tickets/features/home/models/spoken_language.dart';

import 'genres_model.dart';

class MovieModel {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String backdropPath;
  final String posterPath;
  final int runtime;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final String releaseDate;
  final int budget;
  final int revenue;
  final String status;
  final String tagline;
  final bool adult;
  final bool video;
  final String originalLanguage;
  final String? homepage;
  final String? imdbId;


  final List<String> originCountry;
  final List<GenresModel> genres;
  final List<ProductionCompany> productionCompanies;
  final List<ProductionCountry> productionCountries;
  final List<SpokenLanguage> spokenLanguages;

  MovieModel({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.backdropPath,
    required this.posterPath,
    required this.runtime,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.releaseDate,
    required this.budget,
    required this.revenue,
    required this.status,
    required this.tagline,
    required this.adult,
    required this.video,
    required this.originalLanguage,
    required this.homepage,
    required this.imdbId,
    required this.originCountry,
    required this.genres,
    required this.productionCompanies,
    required this.productionCountries,
    required this.spokenLanguages,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      posterPath: json['poster_path'] ?? '',
      runtime: json['runtime'] ?? 0,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      popularity: (json['popularity'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      budget: json['budget'] ?? 0,
      revenue: json['revenue'] ?? 0,
      status: json['status'] ?? '',
      tagline: json['tagline'] ?? '',
      adult: json['adult'] ?? false,
      video: json['video'] ?? false,
      originalLanguage: json['original_language'] ?? '',
      homepage: json['homepage'],
      imdbId: json['imdb_id'],
      originCountry: List<String>.from(json['origin_country'] ?? []),
      genres: (json['genres'] as List? ?? [])
          .map((e) => GenresModel.fromJson(e))
          .toList(),
      productionCompanies: (json['production_companies'] as List? ?? [])
          .map((e) => ProductionCompany.fromJson(e))
          .toList(),
      productionCountries: (json['production_countries'] as List? ?? [])
          .map((e) => ProductionCountry.fromJson(e))
          .toList(),
      spokenLanguages: (json['spoken_languages'] as List? ?? [])
          .map((e) => SpokenLanguage.fromJson(e))
          .toList(),
    );
  }
}