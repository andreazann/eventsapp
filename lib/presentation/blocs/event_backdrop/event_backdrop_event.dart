part of 'event_backdrop_bloc.dart';

abstract class EventBackdropEvent extends Equatable {
  const EventBackdropEvent();

  @override
  List<Object> get props => [];
}

class EventBackdropChangedEvent extends EventBackdropEvent {
  final EventEntity event;

  const EventBackdropChangedEvent(this.event);

  @override
  List<Object> get props => [event];
}