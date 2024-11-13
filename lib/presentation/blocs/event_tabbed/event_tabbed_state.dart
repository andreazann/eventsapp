part of 'event_tabbed_bloc.dart';

abstract class EventTabbedState extends Equatable {
  final int currentTabIndex;

  const EventTabbedState({this.currentTabIndex});

  @override
  List<Object> get props => [currentTabIndex];
}

class EventTabbedInitial extends EventTabbedState {}

class EventTabChanged extends EventTabbedState {
  final List<EventEntity> events;

  const EventTabChanged({int currentTabIndex, this.events})
      : super(currentTabIndex: currentTabIndex);

  @override
  List<Object> get props => [currentTabIndex, events];
}

class EventTabLoadError extends EventTabbedState {
  const EventTabLoadError({int currentTabIndex})
      : super(currentTabIndex: currentTabIndex);
}