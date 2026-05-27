import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../features/payment/models/booking_model.dart';
import '../../features/home/models/movie_model.dart';
import '../../features/home/models/genres_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cinema_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Incremented version to trigger onUpgrade
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createMoviesTables(db);
    }
  }

  Future _createDB(Database db, int version) async {
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    // 1. Table Bookings (History)
    await db.execute('''
CREATE TABLE bookings (
  localId $idType,
  id TEXT,
  userId $textType,
  movieId $integerType,
  movieTitle $textType,
  moviePoster $textType,
  cinemaName $textType,
  cinemaAddress $textType,
  bookingDate $textType,
  bookingTime $textType,
  seats $textType,
  totalAmount $realType,
  paymentMethod $textType,
  orderId $textType,
  createdAt $textType,
  status $textType
)
''');

    await _createMoviesTables(db);
  }

  Future _createMoviesTables(Database db) async {
    // 2. Table Movies (Cache)
    await db.execute('''
CREATE TABLE movies (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  overview TEXT,
  posterPath TEXT,
  backdropPath TEXT,
  voteAverage REAL,
  releaseDate TEXT,
  popularity REAL,
  runtime INTEGER
)
''');

    // 3. Table Genres
    await db.execute('''
CREATE TABLE genres (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
)
''');

    // 4. Junction Table Movie-Genre (Many-to-Many)
    await db.execute('''
CREATE TABLE movie_genres (
  movieId INTEGER,
  genreId INTEGER,
  PRIMARY KEY (movieId, genreId),
  FOREIGN KEY (movieId) REFERENCES movies (id) ON DELETE CASCADE,
  FOREIGN KEY (genreId) REFERENCES genres (id) ON DELETE CASCADE
)
''');
  }

  // --- BOOKING OPERATIONS ---

  Future<int> insertBooking(BookingModel booking) async {
    final db = await instance.database;
    final map = booking.toMap();
    map['seats'] = jsonEncode(booking.seats);
    map['createdAt'] = booking.createdAt.toIso8601String();
    map['id'] = booking.id;
    return await db.insert('bookings', map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<BookingModel>> getAllBookings() async {
    final db = await instance.database;
    final result = await db.query('bookings', orderBy: 'createdAt DESC');
    return result.map((json) {
      final map = Map<String, dynamic>.from(json);
      if (map['seats'] is String) map['seats'] = jsonDecode(map['seats'] as String);
      return BookingModel.fromMap(map, map['id'] ?? '');
    }).toList();
  }

  // --- MOVIE CACHE OPERATIONS ---

  Future<void> saveMovies(List<MovieModel> movies) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      for (var movie in movies) {
        // Insert Movie
        await txn.insert('movies', {
          'id': movie.id,
          'title': movie.title,
          'overview': movie.overview,
          'posterPath': movie.posterPath,
          'backdropPath': movie.backdropPath,
          'voteAverage': movie.voteAverage,
          'releaseDate': movie.releaseDate,
          'popularity': movie.popularity,
          'runtime': movie.runtime,
        }, conflictAlgorithm: ConflictAlgorithm.replace);

        // Insert Genres & Junction
        for (var genre in movie.genres) {
          await txn.insert('genres', {
            'id': genre.id,
            'name': genre.name,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);

          await txn.insert('movie_genres', {
            'movieId': movie.id,
            'genreId': genre.id,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      }
    });
  }

  Future<List<MovieModel>> getCachedMovies() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> movieMaps = await db.query('movies');
    
    List<MovieModel> movies = [];
    for (var map in movieMaps) {
      // Get genres for this movie
      final List<Map<String, dynamic>> genreMaps = await db.rawQuery('''
        SELECT g.* FROM genres g
        INNER JOIN movie_genres mg ON g.id = mg.genreId
        WHERE mg.movieId = ?
      ''', [map['id']]);

      final genres = genreMaps.map((g) => GenresModel.fromJson(g)).toList();
      
      // Reconstruct MovieModel (using fromListJson or custom logic)
      movies.add(MovieModel(
        id: map['id'],
        title: map['title'],
        originalTitle: '', // Optional/Not cached
        overview: map['overview'] ?? '',
        backdropPath: map['backdropPath'] ?? '',
        posterPath: map['posterPath'] ?? '',
        runtime: map['runtime'] ?? 0,
        voteAverage: map['voteAverage'] ?? 0.0,
        voteCount: 0,
        popularity: map['popularity'] ?? 0.0,
        releaseDate: map['releaseDate'] ?? '',
        budget: 0,
        revenue: 0,
        status: '',
        tagline: '',
        adult: false,
        video: false,
        originalLanguage: '',
        homepage: null,
        imdbId: null,
        originCountry: [],
        genres: genres,
        productionCompanies: [],
        productionCountries: [],
        spokenLanguages: [],
      ));
    }
    return movies;
  }

  Future<void> clearMovieCache() async {
    final db = await instance.database;
    await db.delete('movies');
    await db.delete('genres');
    await db.delete('movie_genres');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
