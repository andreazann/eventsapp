part of 'event_tabbed_bloc.dart';

abstract class EventTabbedEvent extends Equatable {
  const EventTabbedEvent();

  @override
  List<Object> get props => [];
}

class EventTabChangedEvent extends EventTabbedEvent {
  final int currentTabIndex;

  const EventTabChangedEvent({this.currentTabIndex = 0});

  @override
  List<Object> get props => [currentTabIndex];
}