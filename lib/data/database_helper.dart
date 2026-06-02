import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/wine_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // Abre la base de datos o la crea si no existe
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('wine_favorites.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Crea la tabla de favoritos
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY,
        alcohol REAL,
        ph REAL,
        acidity REAL,
        sulphates REAL,
        quality INTEGER,
        type TEXT
      )
    ''');
  }

  // Agrega un vino a favoritos
  Future<void> insertFavorite(WineModel wine) async {
    final db = await instance.database;

    await db.insert(
      'favorites',
      wine.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtiene todos los favoritos
  Future<List<WineModel>> getFavorites() async {
    final db = await instance.database;

    final result = await db.query('favorites');

    return result.map((map) => WineModel.fromMap(map)).toList();
  }

  // Elimina un favorito
  Future<void> deleteFavorite(int id) async {
    final db = await instance.database;

    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Revisa si un vino ya está en favoritos
  Future<bool> isFavorite(int id) async {
    final db = await instance.database;

    final result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty;
  }
}