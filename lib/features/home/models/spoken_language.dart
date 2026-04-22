class SpokenLanguage {
  final String englishName;
  final String isoCode;
  final String name;

  SpokenLanguage({
    required this.englishName,
    required this.isoCode,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
    return SpokenLanguage(
      englishName: json['english_name'] ?? '',
      isoCode: json['iso_639_1'] ?? '',
      name: json['name'] ?? '',
    );
  }
}