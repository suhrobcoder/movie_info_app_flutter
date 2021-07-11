part of 'movie_bloc.dart';

@immutable
abstract class MovieState {
  final List<Movie> movies;
  final MovieCategory category;
  final int page;
  final bool loading;
  final int selectedGenreId;

  MovieState(this.movies, this.category, this.page, this.selectedGenreId,
      {this.loading: false});
}

class MovieLoadingState extends MovieState {
  MovieLoadingState(
      List<Movie> movies, MovieCategory category, int page, int selectedGenreId)
      : super(movies, category, page, selectedGenreId, loading: true);
}

class MovieLoadedState extends MovieState {
  MovieLoadedState(
      List<Movie> movies, MovieCategory category, int page, int selectedGenreId)
      : super(movies, category, page, selectedGenreId);
}

class MovieLoadErrorState extends MovieState {
  final String error;

  MovieLoadErrorState(List<Movie> movies, MovieCategory category, int page,
      this.error, int selectedGenreId)
      : super(movies, category, page, selectedGenreId);
}
