import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:movie_info_app_flutter/data/repository/saved_movies_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final SavedMoviesRepository repository;
  FavoritesBloc(this.repository) : super(FavoritesLoading()) {
    on<LoadFavorites>((event, emit) async {
      emit(FavoritesLoading());
      List<Movie> movies = await repository.getAllMovies();
      emit(FavoritesLoaded(movies));
    });
  }
}
