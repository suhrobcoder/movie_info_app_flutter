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
    print("Event : ${state.toString}");
    if (event is LoadMoviesEvent) {
      yield MovieLoadingState(state.movies, state.category, state.page);
      MovieListResponse res = await loadMovies(state.page + 1);
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
      MovieListResponse res = await loadMovies(1);
      if (res.error.isEmpty) {
        var movies = res.results;
        yield MovieLoadedState(movies, state.category, 1);
      } else {
        yield MovieLoadErrorState([], state.category, 0, res.error);
      }
    }
    if (event is CategorySelectEvent) {
      yield MovieLoadingState([], event.category, 0);
      MovieListResponse res = await loadMovies(1);
      if (res.error.isEmpty) {
        var movies = res.results;
        yield MovieLoadedState(movies, event.category, 1);
      } else {
        yield MovieLoadErrorState([], event.category, 0, res.error);
      }
    }
  }

  Future<MovieListResponse> loadMovies(int page) async {
    switch (state.category) {
      case MovieCategory.POPULAR:
        return await repository.getPopularMovies(page);
      case MovieCategory.TOP_RATED:
        return await repository.getTopRatedMovies(page);
      case MovieCategory.UPCOMING:
        return await repository.getUpcomingMovies(page);
    }
  }
}

enum MovieCategory { POPULAR, TOP_RATED, UPCOMING }
