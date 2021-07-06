part of 'rate_cubit.dart';

@immutable
abstract class RateState {}

class RateInitial extends RateState {}

class RateRunning extends RateState {}

class RateCompleted extends RateState {
  final String message;

  RateCompleted(this.message);
}
