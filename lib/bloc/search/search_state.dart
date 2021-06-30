part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Movie> movies;
  SearchLoaded(this.movies);
}

class Searching extends SearchState {}

class SearchError extends SearchState {
  final String error;

  SearchError(this.error);
}
