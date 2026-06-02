import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wine_model.dart';

class ApiService {
  // Para emulador Android se usa 10.0.2.2 en vez de localhost
  static const String baseUrl = 'http://192.168.93.87:8000';

  Future<List<WineModel>> getWines() async {
    final url = Uri.parse('$baseUrl/wines');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((item) {
        return WineModel(
          id: item['id'],
          alcohol: item['alcohol'].toDouble(),
          ph: item['ph'].toDouble(),
          acidity: item['acidity'].toDouble(),
          sulphates: item['sulphates'].toDouble(),
          quality: item['quality'],
          type: item['type'],
        );
      }).toList();
    } else {
      throw Exception('Error al cargar los vinos desde la API');
    }
  }
}