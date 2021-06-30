import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MovieRepository repository;
  SearchBloc(this.repository) : super(SearchInitial());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchExecuteEvent) {
      yield Searching();
      var searchResponse = await repository.searchMovies(event.query, 1);
      if (searchResponse.error.isEmpty) {
        yield SearchLoaded(searchResponse.results);
      } else {
        yield SearchError(searchResponse.error);
      }
    }
    if (event is SearchRetryEvent) {
      yield Searching();
      var searchResponse = await repository.searchMovies(event.query, 1);
      if (searchResponse.error.isEmpty) {
        yield SearchLoaded(searchResponse.results);
      } else {
        yield SearchError(searchResponse.error);
      }
    }
  }
}
