class CinemaModel {
  final String id;
  final String name;
  final String address;

  CinemaModel({
    required this.id,
    required this.name,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
    };
  }

  factory CinemaModel.fromMap(Map<String, dynamic> map, String id) {
    return CinemaModel(
      id: id,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
    );
  }
}

class RoomModel {
  final String id;
  final String name;
  final int totalRows;
  final int totalCols;

  RoomModel({
    required this.id,
    required this.name,
    required this.totalRows,
    required this.totalCols,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'totalRows': totalRows,
      'totalCols': totalCols,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map, String id) {
    return RoomModel(
      id: id,
      name: map['name'] ?? '',
      totalRows: map['totalRows'] ?? 0,
      totalCols: map['totalCols'] ?? 0,
    );
  }
}
