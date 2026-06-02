import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../models/wine_model.dart';

class WineData {
  static Future<List<WineModel>> loadWines() async {
    List<WineModel> allWines = [];

    final redCsv = await rootBundle.loadString('assets/winequality-red.csv');
    final whiteCsv = await rootBundle.loadString('assets/winequality-white.csv');

    allWines.addAll(_readCsv(redCsv, 'Red', 1));
    allWines.addAll(_readCsv(whiteCsv, 'White', 5000));

    return allWines;
  }

  static List<WineModel> _readCsv(String csvText, String type, int startId) {
    final rows = const CsvToListConverter(
      fieldDelimiter: ';',
      eol: '\n',
    ).convert(csvText);

    List<WineModel> wines = [];

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      wines.add(
        WineModel(
          id: startId + i,
          acidity: (row[0] as num).toDouble(),
          ph: (row[8] as num).toDouble(),
          sulphates: (row[9] as num).toDouble(),
          alcohol: (row[10] as num).toDouble(),
          quality: (row[11] as num).toInt(),
          type: type,
        ),
      );
    }

    return wines;
  }
}