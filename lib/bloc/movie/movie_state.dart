part of 'movie_bloc.dart';

@immutable
abstract class MovieState {
  final List<Movie> movies;
  final MovieCategory category;
  final int page;
  final bool loading;

  MovieState(this.movies, this.category, this.page, {this.loading: false});
}

class MovieLoadingState extends MovieState {
  MovieLoadingState(List<Movie> movies, MovieCategory category, int page)
      : super(movies, category, page, loading: true);
}

class MovieLoadedState extends MovieState {
  MovieLoadedState(List<Movie> movies, MovieCategory category, int page)
      : super(movies, category, page);
}

class MovieLoadErrorState extends MovieState {
  final String error;

  MovieLoadErrorState(
      List<Movie> movies, MovieCategory category, int page, this.error)
      : super(movies, category, page);
}
