import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:movie_info_app_flutter/data/model/movie_list_response.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;
  MovieBloc(this.repository)
      : super(MovieLoadingState([], MovieCategory.POPULAR, 0));

  @override
  Stream<MovieState> mapEventToState(
    MovieEvent event,
  ) async* {
    if (event is LoadMoviesEvent) {
      yield MovieLoadingState(state.movies, state.category, state.page);
      MovieListResponse res = await repository.getPopularMovies(state.page + 1);
      if (res.error.isEmpty) {
        var movies = state.movies;
        movies.addAll(res.results);
        yield MovieLoadedState(movies, state.category, state.page + 1);
      } else {
        yield MovieLoadErrorState(
            state.movies, state.category, state.page, res.error);
      }
    }
    if (event is RefreshEvent) {
      yield MovieLoadingState([], state.category, 0);
      MovieListResponse res = await repository.getPopularMovies(1);
      if (res.error.isEmpty) {
        var movies = res.results;
        yield MovieLoadedState(movies, state.category, 1);
      } else {
        yield MovieLoadErrorState([], state.category, 0, res.error);
      }
    }
    if (event is CategorySelectEvent) {
      yield MovieLoadedState([], event.category, 0);
      MovieListResponse res = await repository.getPopularMovies(1);
      if (res.error.isEmpty) {
        var movies = res.results;
        yield MovieLoadedState(movies, event.category, 1);
      } else {
        yield MovieLoadErrorState([], event.category, 0, res.error);
      }
    }
  }
}

enum MovieCategory { POPULAR, TOP_RATED, UPCOMING }
