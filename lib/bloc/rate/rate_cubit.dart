import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movie_info_app_flutter/data/repository/movie_repository.dart';

part 'rate_state.dart';

class RateCubit extends Cubit<RateState> {
  final MovieRepository repository;
  final int movieId;
  RateCubit(this.repository, this.movieId) : super(RateInitial());

  Future rateMovie(int rating) async {
    emit(RateRunning());
    String res = await repository.rateMovie(movieId, rating);
    emit(RateCompleted(res));
  }
}
