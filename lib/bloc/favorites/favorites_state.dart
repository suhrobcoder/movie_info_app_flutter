part of 'favorites_bloc.dart';

@immutable
abstract class FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Movie> movies;

  FavoritesLoaded(this.movies);
}
