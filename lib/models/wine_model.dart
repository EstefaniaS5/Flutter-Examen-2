class WineModel {
  final int id;
  final double alcohol;
  final double ph;
  final double acidity;
  final double sulphates;
  final int quality;
  final String type;

  WineModel({
    required this.id,
    required this.alcohol,
    required this.ph,
    required this.acidity,
    required this.sulphates,
    required this.quality,
    required this.type,
  });

  // Convierte el objeto a Map para guardarlo en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'alcohol': alcohol,
      'ph': ph,
      'acidity': acidity,
      'sulphates': sulphates,
      'quality': quality,
      'type': type,
    };
  }

  // Convierte un Map de SQLite a objeto WineModel
  factory WineModel.fromMap(Map<String, dynamic> map) {
    return WineModel(
      id: map['id'],
      alcohol: map['alcohol'],
      ph: map['ph'],
      acidity: map['acidity'],
      sulphates: map['sulphates'],
      quality: map['quality'],
      type: map['type'],
    );
  }
}