import 'movie_model.dart';

class PopularModel {
  int page;
  List<MovieModel> results;
  int totalPages;
  int totalResults;

  PopularModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory PopularModel.fromJson(Map<String, dynamic> json) => PopularModel(
    page: json["page"],
    results: List<MovieModel>.from(
      json["results"].map((x) => MovieModel.fromJson(x)),
    ),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toString())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}
