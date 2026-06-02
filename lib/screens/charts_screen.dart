import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/wine_model.dart';

class ChartsScreen extends StatelessWidget {
  final List<WineModel> wines;

  const ChartsScreen({
    super.key,
    required this.wines,
  });

  Map<int, int> getQualityDistribution() {
    Map<int, int> distribution = {};

    for (var wine in wines) {
      distribution[wine.quality] = (distribution[wine.quality] ?? 0) + 1;
    }

    return distribution;
  }

  List<WineModel> getTopWines() {
    List<WineModel> sorted = List.from(wines);

    sorted.sort((a, b) {
      int byQuality = b.quality.compareTo(a.quality);

      if (byQuality != 0) {
        return byQuality;
      }

      return b.alcohol.compareTo(a.alcohol);
    });

    return sorted.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    final distribution = getQualityDistribution();
    final qualities = distribution.keys.toList()..sort();
    final topWines = getTopWines();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráficos y ranking'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          const Text(
            'Distribución de calidad',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                  ),
                ),
                barGroups: qualities.map((quality) {
                  return BarChartGroupData(
                    x: quality,
                    barRods: [
                      BarChartRodData(
                        toY: distribution[quality]!.toDouble(),
                        width: 18,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Ranking Top 10 vinos',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ...topWines.map((wine) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(wine.quality.toString()),
                ),
                title: Text('${wine.type} wine'),
                subtitle: Text(
                  'Alcohol: ${wine.alcohol} | pH: ${wine.ph} | Sulfatos: ${wine.sulphates}',
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}