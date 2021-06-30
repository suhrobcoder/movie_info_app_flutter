import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_info_app_flutter/data/model/genre.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';

part 'genre_event.dart';
part 'genre_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  final MovieRepository repository;
  GenreBloc(this.repository) : super(GenreInitial());

  final Genre defaultGenre = Genre(-1, "All");

  @override
  Stream<GenreState> mapEventToState(
    GenreEvent event,
  ) async* {
    if (event is LoadGenresEvent) {
      yield GenreInitial();
      var genreResponse = await repository.getGenres();
      if (genreResponse.error.isEmpty) {
        var genres = [defaultGenre];
        genres.addAll(genreResponse.genres);
        yield GenresLoaded(defaultGenre, genres);
      } else {
        yield GenresLoadError(genreResponse.error);
      }
    }
    if (event is SelectGenreEvent) {
      if (state is GenresLoaded) {
        yield GenresLoaded(event.genre, (state as GenresLoaded).genres);
      }
    }
  }
}
