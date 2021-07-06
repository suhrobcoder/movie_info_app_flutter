import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'moviedetails_event.dart';
part 'moviedetails_state.dart';

class MoviedetailsBloc extends Bloc<MoviedetailsEvent, MoviedetailsState> {
  MoviedetailsBloc() : super(MoviedetailsInitial());

  @override
  Stream<MoviedetailsState> mapEventToState(
    MoviedetailsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
