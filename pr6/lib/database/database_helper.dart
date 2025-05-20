import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('movies.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        year INTEGER NOT NULL,
        genre TEXT NOT NULL,
        imagePath TEXT
      )
    ''');
  }

  Future<int> insertMovie(Movie movie) async {
    final db = await instance.database;
    return await db.insert('movies', movie.toMap());
  }

  Future<List<Movie>> getAllMovies() async {
    final db = await instance.database;
    final result = await db.query('movies');
    return result.map((json) => Movie.fromMap(json)).toList();
  }

  Future<int> updateMovie(Movie movie) async {
    final db = await instance.database;
    return await db.update(
      'movies',
      movie.toMap(),
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> deleteMovie(int id) async {
    final db = await instance.database;
    return await db.delete(
      'movies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}