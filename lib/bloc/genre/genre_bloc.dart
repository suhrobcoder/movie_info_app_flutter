import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_info_app_flutter/data/model/genre.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';

part 'genre_event.dart';
part 'genre_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  final MovieRepository repository;

  final Genre defaultGenre = Genre(-1, "All");

  GenreBloc(this.repository) : super(GenreInitial()) {
    on<LoadGenresEvent>((event, emit) async {
      emit(GenreInitial());
      var genreResponse = await repository.getGenres();
      if (genreResponse.error.isEmpty) {
        var genres = [defaultGenre];
        genres.addAll(genreResponse.genres);
        emit(GenresLoaded(defaultGenre, genres));
      } else {
        emit(GenresLoadError(genreResponse.error));
      }
    });
    on<SelectGenreEvent>((event, emit) {
      if (state is GenresLoaded) {
        emit(GenresLoaded(event.genre, (state as GenresLoaded).genres));
      }
    });
  }
}
