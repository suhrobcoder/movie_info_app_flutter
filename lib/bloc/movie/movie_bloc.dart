import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:movie_info_app_flutter/data/model/movie_list_response.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;

  CancelToken? _cancelToken;

  MovieBloc(this.repository)
      : super(const MovieLoadingState([], MovieCategory.POPULAR, 0, -1)) {
    on<LoadMoviesEvent>((event, emit) async {
      emit(MovieLoadingState(
          state.movies, state.category, state.page, state.selectedGenreId));
      MovieListResponse res = await loadMovies(state.page + 1);
      if (res.error.isEmpty) {
        emit(MovieLoadedState(state.movies + res.results, state.category,
            state.page + 1, state.selectedGenreId));
      } else {
        emit(MovieLoadErrorState(state.movies, state.category, state.page,
            res.error, state.selectedGenreId));
      }
    });

    on<RefreshEvent>((event, emit) async {
      emit(MovieLoadingState(
          const [], state.category, 0, state.selectedGenreId));
      MovieListResponse res = await loadMovies(1);
      if (res.error.isEmpty) {
        var movies = res.results;
        emit(
            MovieLoadedState(movies, state.category, 1, state.selectedGenreId));
      } else {
        emit(MovieLoadErrorState(
            const [], state.category, 0, res.error, state.selectedGenreId));
      }
    });

    on<CategorySelectEvent>((event, emit) async {
      emit(MovieLoadingState(
          const [], event.category, 0, state.selectedGenreId));
      MovieListResponse res = await loadMovies(1);
      if (res.error.isEmpty) {
        var movies = res.results;
        emit(
            MovieLoadedState(movies, event.category, 1, state.selectedGenreId));
      } else {
        emit(MovieLoadErrorState(
            const [], event.category, 0, res.error, state.selectedGenreId));
      }
    }, transformer: (events, transitionFn) {
      if (state is MovieLoadingState) {
        _cancelToken?.cancel();
      }
      return events.asyncExpand((event) => transitionFn(event));
    });

    on<GenreSelectedEvent>((event, emit) {
      emit(MovieLoadedState(
          state.movies, state.category, state.page, event._selectedGenreId));
    });
  }

  List<Movie> getFilteredMovies() {
    List<Movie> filteredMovies = state.movies
        .where((movie) =>
            state.selectedGenreId == -1 ||
            (movie.genreIds?.contains(state.selectedGenreId) ?? false))
        .toList();
    return filteredMovies;
  }

  Future<MovieListResponse> loadMovies(int page) async {
    CancelToken cancelToken = CancelToken();
    _cancelToken = cancelToken;
    switch (state.category) {
      case MovieCategory.POPULAR:
        return await repository.getPopularMovies(page, cancelToken);
      case MovieCategory.TOP_RATED:
        return await repository.getTopRatedMovies(page, cancelToken);
      case MovieCategory.UPCOMING:
        return await repository.getUpcomingMovies(page, cancelToken);
    }
  }
}

// ignore: constant_identifier_names
enum MovieCategory { POPULAR, TOP_RATED, UPCOMING }
