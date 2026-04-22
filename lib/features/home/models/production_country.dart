class ProductionCountry {
  final String isoCode;
  final String name;

  ProductionCountry({
    required this.isoCode,
    required this.name,
  });

  factory ProductionCountry.fromJson(Map<String, dynamic> json) {
    return ProductionCountry(
      isoCode: json['iso_3166_1'] ?? '',
      name: json['name'] ?? '',
    );
  }
}