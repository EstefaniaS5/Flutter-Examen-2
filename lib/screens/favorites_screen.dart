import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/wine_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<WineModel> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data = await DatabaseHelper.instance.getFavorites();

    setState(() {
      favorites = data;
    });
  }

  Future<void> deleteFavorite(int id) async {
    await DatabaseHelper.instance.deleteFavorite(id);
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos SQLite'),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text('No hay vinos favoritos todavía'),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final wine = favorites[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(wine.quality.toString()),
                    ),
                    title: Text('${wine.type} wine'),
                    subtitle: Text(
                      'Alcohol: ${wine.alcohol} | pH: ${wine.ph} | Sulfatos: ${wine.sulphates}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteFavorite(wine.id);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}