import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/wine_model.dart';

class WineListScreen extends StatefulWidget {
  final List<WineModel> wines;

  const WineListScreen({
    super.key,
    required this.wines,
  });

  @override
  State<WineListScreen> createState() => _WineListScreenState();
}

class _WineListScreenState extends State<WineListScreen> {
  int minQuality = 5;
  double minAlcohol = 8.0;
  String selectedType = 'All';

  List<WineModel> getFilteredWines() {
    return widget.wines.where((wine) {
      final qualityOk = wine.quality >= minQuality;
      final alcoholOk = wine.alcohol >= minAlcohol;
      final typeOk = selectedType == 'All' || wine.type == selectedType;

      return qualityOk && alcoholOk && typeOk;
    }).toList();
  }

  Future<void> addFavorite(WineModel wine) async {
    await DatabaseHelper.instance.insertFavorite(wine);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vino guardado en favoritos')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredWines = getFilteredWines();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de vinos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text('Calidad mínima: $minQuality'),
                    Slider(
                      value: minQuality.toDouble(),
                      min: 3,
                      max: 9,
                      divisions: 6,
                      label: minQuality.toString(),
                      onChanged: (value) {
                        setState(() {
                          minQuality = value.toInt();
                        });
                      },
                    ),

                    Text('Alcohol mínimo: ${minAlcohol.toStringAsFixed(1)}'),
                    Slider(
                      value: minAlcohol,
                      min: 8,
                      max: 15,
                      divisions: 14,
                      label: minAlcohol.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          minAlcohol = value;
                        });
                      },
                    ),

                    DropdownButton<String>(
                      value: selectedType,
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('Todos')),
                        DropdownMenuItem(value: 'Red', child: Text('Vino rojo')),
                        DropdownMenuItem(value: 'White', child: Text('Vino blanco')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedType = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          Text(
            'Resultados encontrados: ${filteredWines.length}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredWines.length,
              itemBuilder: (context, index) {
                final wine = filteredWines[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(wine.quality.toString()),
                    ),
                    title: Text('${wine.type} wine - Calidad ${wine.quality}'),
                    subtitle: Text(
                      'Alcohol: ${wine.alcohol} | pH: ${wine.ph} | Acidez: ${wine.acidity}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        addFavorite(wine);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}