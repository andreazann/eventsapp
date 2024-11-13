part of 'search_event_bloc.dart';

abstract class SearchEventEvent extends Equatable {
  const SearchEventEvent();

  @override
  List<Object> get props => [];
}

class SearchTermChangedEvent extends SearchEventEvent {
  final String searchTerm;

  SearchTermChangedEvent(this.searchTerm);

  @override
  List<Object> get props => [searchTerm];
}