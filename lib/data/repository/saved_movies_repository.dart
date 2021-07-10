import 'package:movie_info_app_flutter/data/database/db_helper.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';

class SavedMoviesRepository {
  final DBHelper dbHelper;

  SavedMoviesRepository(this.dbHelper);

  Future insertMovie(Movie movie) async {
    await dbHelper.insertMovie(movie);
  }

  Future<Movie?> getMovieById(int movieId) async {
    return await dbHelper.getMovieById(movieId);
  }

  Future<List<Movie>> getAllMovies() async {
    return await dbHelper.getAllMovies();
  }

  Future<void> deleteMovie(int movieId) async {
    await dbHelper.deleteMovie(movieId);
  }

  Future<bool> isMovieLiked(int movieId) async {
    return await dbHelper.isMovieLiked(movieId);
  }
}
