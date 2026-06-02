import 'package:flutter/material.dart';
import '../data/wine_data.dart';
import '../models/wine_model.dart';
import '../widgets/metric_card.dart';
import 'wine_list_screen.dart';
import 'favorites_screen.dart';
import 'charts_screen.dart';
import '../data/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<WineModel> wines = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await WineData.loadWines();

    setState(() {
      wines = data;
      loading = false;
    });
  }

  double getAverageQuality() {
    double total = 0;

    for (var wine in wines) {
      total += wine.quality;
    }

    return total / wines.length;
  }

  int getBestQuality() {
    int best = 0;

    for (var wine in wines) {
      if (wine.quality > best) {
        best = wine.quality;
      }
    }

    return best;
  }

  int getGoodWines() {
    int count = 0;

    for (var wine in wines) {
      if (wine.quality >= 7) {
        count++;
      }
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wine Quality Analyzer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const Text(
              'Análisis del dataset Wine Quality de UCI',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 15),

            MetricCard(
              title: 'Total de vinos',
              value: wines.length.toString(),
              icon: Icons.wine_bar,
            ),

            MetricCard(
              title: 'Calidad promedio',
              value: getAverageQuality().toStringAsFixed(2),
              icon: Icons.analytics,
            ),

            MetricCard(
              title: 'Mejor calidad',
              value: getBestQuality().toString(),
              icon: Icons.star,
            ),

            MetricCard(
              title: 'Vinos buenos',
              value: getGoodWines().toString(),
              icon: Icons.thumb_up,
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WineListScreen(wines: wines),
                    ),
                  );
                },
                child: const Text('Ver dataset y filtros'),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChartsScreen(wines: wines),
                    ),
                  );
                },
                child: const Text('Ver gráficos y ranking'),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FavoritesScreen(),
                    ),
                  );
                },
                child: const Text('Ver favoritos SQLite'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}