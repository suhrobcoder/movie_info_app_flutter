part of 'genre_bloc.dart';

@immutable
abstract class GenreState {}

class GenreInitial extends GenreState {}

class GenresLoaded extends GenreState {
  final Genre selectedGenre;
  final List<Genre> genres;

  GenresLoaded(this.selectedGenre, this.genres);
}

class GenresLoadError extends GenreState {
  final String error;

  GenresLoadError(this.error);
}
