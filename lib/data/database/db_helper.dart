import 'dart:io';

import 'package:movie_info_app_flutter/data/model/genre.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  final _dbName = "movie_info.db";
  final _dbVersion = 1;

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = join(docsDir.path, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE genres(
        genre_id INTEGER PRIMARY KEY,
        name TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE movies(
        movie_id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        overview TEXT NOT NULL,
        backdrop_path TEXT,
        poster_path TEXT,
        release_date TEXT,
        runtime INTEGER,
        video INTEGER NOT NULL,
        vote_average REAL,
        vote_count INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE movie_genre(
        movie_id INTEGER NOT NULL,
        genre_id INTEGER NOT NULL,
        PRIMARY KEY (movie_id, genre_id)
      )
    ''');
  }

  Future insertGenres(List<Genre> genres) async {
    Database db = await instance.database;
    Batch batch = db.batch();
    for (Genre genre in genres) {
      var genreMap = {"genre_id": genre.id, "name": genre.name};
      batch.insert("genres", genreMap, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<List<Genre>> getGenresByMovieId(int movieId) async {
    Database db = await instance.database;
    List<Map<String, Object?>> allGenreIds = await db.query("movie_genre",
        columns: ["genre_id"], where: "movie_id = ?", whereArgs: [movieId]);
    List<Genre> allGenres = [];
    for (var genreId in allGenreIds.toList()) {
      var genre =
          await db.query("genres", where: "genre_id = ?", whereArgs: [genreId["genre_id"] ?? 0]);
      if (genre.isNotEmpty) {
        allGenres.add(Genre(genre[0]["genre_id"] as int, genre[0]["name"] as String));
      }
    }
    return allGenres;
  }

  Future insertMovieGenre(int movieId, List<int> genreIds) async {
    Database db = await instance.database;
    Batch batch = db.batch();
    for (int genreId in genreIds) {
      var value = {"movie_id": movieId, "genre_id": genreId};
      batch.insert("movie_genre", value, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future insertMovie(Movie movie) async {
    Database db = await instance.database;
    Map<String, Object?> movieMap = {
      "movie_id": movie.id,
      "title": movie.title,
      "overview": movie.overview,
      "backdrop_path": movie.backdropPath,
      "poster_path": movie.posterPath,
      "release_date": movie.releaseDate,
      "runtime": movie.runtime,
      "video": movie.video ? 1 : 0,
      "vote_average": movie.voteAverage,
      "vote_count": movie.voteCount
    };
    List<int> genreIds = movie.genres?.map((e) => e.id).toList() ?? [];
    await insertMovieGenre(movie.id, genreIds);
    await insertGenres(movie.genres ?? []);
    await db.insert("movies", movieMap, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Movie>> getAllMovies() async {
    Database db = await instance.database;
    var moviesMap = await db.query("movies");
    return moviesMap
        .map((e) => Movie(
            e["movie_id"] as int,
            e["title"] as String,
            e["overview"] as String,
            e["backdrop_path"] as String?,
            e["poster_path"] as String?,
            null,
            null,
            e["release_date"] as String?,
            e["runtime"] as int?,
            (e["video"] as int) > 0,
            e["vote_average"] as double?,
            e["vote_count"] as int?))
        .toList();
  }

  Future<Movie?> getMovieById(int movieId) async {
    Database db = await instance.database;
    var moviesMap = await db.query("movies", where: "movie_id = ?", whereArgs: [movieId]);
    var genres = await getGenresByMovieId(movieId);
    if (moviesMap.isEmpty) {
      return null;
    }
    var movie = Movie(
        moviesMap[0]["movie_id"] as int,
        moviesMap[0]["title"] as String,
        moviesMap[0]["overview"] as String,
        moviesMap[0]["backdrop_path"] as String,
        moviesMap[0]["poster_path"] as String,
        null,
        genres,
        moviesMap[0]["release_date"] as String,
        moviesMap[0]["runtime"] as int,
        (moviesMap[0]["video"] as int) > 0,
        moviesMap[0]["vote_average"] as double,
        moviesMap[0]["vote_count"] as int);
    return movie;
  }

  Future<void> deleteMovie(int movieId) async {
    Database db = await instance.database;
    await db.delete("movies", where: "movie_id = ?", whereArgs: [movieId]);
    await db.delete("movie_genre", where: "movie_id = ?", whereArgs: [movieId]);
  }

  Future<bool> isMovieLiked(int movieId) async {
    Database db = await instance.database;
    return (Sqflite.firstIntValue(
              await db.rawQuery("SELECT COUNT(*) FROM movies WHERE movie_id=$movieId"),
            ) ??
            0) >
        0;
  }
}
