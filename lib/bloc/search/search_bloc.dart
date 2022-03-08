import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_info_app_flutter/data/model/movie.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MovieRepository repository;
  SearchBloc(this.repository) : super(SearchInitial()) {
    on<SearchExecuteEvent>((event, emit) async {
      emit(Searching());
      var searchResponse = await repository.searchMovies(event.query, 1);
      if (searchResponse.error.isEmpty) {
        emit(SearchLoaded(searchResponse.results));
      } else {
        emit(SearchError(searchResponse.error));
      }
    });

    on<SearchRetryEvent>((event, emit) async {
      emit(Searching());
      var searchResponse = await repository.searchMovies(event.query, 1);
      if (searchResponse.error.isEmpty) {
        emit(SearchLoaded(searchResponse.results));
      } else {
        emit(SearchError(searchResponse.error));
      }
    });
  }
}
