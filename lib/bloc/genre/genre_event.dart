part of 'genre_bloc.dart';

@immutable
abstract class GenreEvent {}

class LoadGenresEvent extends GenreEvent {}

class SelectGenreEvent extends GenreEvent {
  final Genre genre;

  SelectGenreEvent(this.genre);
}
