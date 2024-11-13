part of 'event_backdrop_bloc.dart';

abstract class EventBackdropState extends Equatable {
  const EventBackdropState();

  @override
  List<Object> get props => [];
}

class EventBackdropInitial extends EventBackdropState {}

class EventBackdropChanged extends EventBackdropState {
  final EventEntity event;

  const EventBackdropChanged(this.event);

  @override
  List<Object> get props => [event];
}