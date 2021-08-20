import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:movie_info_app_flutter/data/repository/saved_movies_repository.dart';

class MovieLikeBloc {
  final SavedMoviesRepository repository;
  final int movieId;

  MovieLikeBloc(this.repository, this.movieId);

  Future<bool> isMovieLiked() async {
    return await repository.isMovieLiked(movieId);
  }

  Future<bool> likeMovie(Movie movie) async {
    await repository.insertMovie(movie);
    return await isMovieLiked();
  }

  Future<bool> dislikeMovie() async {
    await repository.deleteMovie(movieId);
    return await isMovieLiked();
  }
}
