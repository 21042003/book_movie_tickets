
import 'genres_model.dart';


class ModelDetail{
  final int id;
  final String title;
  final String overview;
  final int runtime;
  final List<GenresModel> genrens;

  ModelDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.runtime,
    required this.genrens,
  });

  factory ModelDetail.fromJson(Map<String, dynamic> json){
    return ModelDetail(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      runtime: json['runtime'],
      genrens: (json['genres'] as List).map((e) => GenresModel.fromJson(e)).toList(),
    );
  }
}
