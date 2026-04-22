class GenresModel {
  int id;
  String name;

  GenresModel({
    required this.id,
    required this.name,
  });

  factory GenresModel.fromJson(Map<String, dynamic> json) => GenresModel(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
