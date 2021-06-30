part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchExecuteEvent extends SearchEvent {
  final String query;

  SearchExecuteEvent(this.query);
}

class SearchRetryEvent extends SearchEvent {
  final String query;

  SearchRetryEvent(this.query);
}
