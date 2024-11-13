part of 'search_event_bloc.dart';

abstract class SearchEventState extends Equatable {
  const SearchEventState();

  @override
  List<Object> get props => [];
}

class SearchEventInitial extends SearchEventState {}

class SearchEventLoaded extends SearchEventState {
  final List<EventEntity> events;

  SearchEventLoaded(this.events);

  @override
  List<Object> get props => [events];
}

class SearchEventLoading extends SearchEventState {}

class SearchEventError extends SearchEventState {
  final AppErrorType errorType;

  SearchEventError(this.errorType);

  @override
  List<Object> get props => [errorType];
}