part of 'movie_bloc.dart';

@immutable
abstract class MovieEvent {}

class LoadMoviesEvent extends MovieEvent {}

class RefreshEvent extends MovieEvent {}

class CategorySelectEvent extends MovieEvent {
  final MovieCategory category;

  CategorySelectEvent(this.category);
}

class GenreSelectedEvent extends MovieEvent {
  final int _selectedGenreId;

  GenreSelectedEvent(this._selectedGenreId);
}
