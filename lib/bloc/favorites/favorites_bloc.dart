import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:movie_info_app_flutter/data/repository/saved_movies_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final SavedMoviesRepository repository;
  FavoritesBloc(this.repository) : super(FavoritesLoading());

  @override
  Stream<FavoritesState> mapEventToState(
    FavoritesEvent event,
  ) async* {
    if (event is LoadFavorites) {
      yield FavoritesLoading();
      List<Movie> movies = await repository.getAllMovies();
      yield FavoritesLoaded(movies);
    }
  }
}
