part of 'event_carousel_bloc.dart';

abstract class EventCarouselState extends Equatable {
  const EventCarouselState();

  @override
  List<Object> get props => [];
}

class EventCarouselInitial extends EventCarouselState {}

class EventCarouselError extends EventCarouselState {}

class EventCarouselLoaded extends EventCarouselState {
  final List<EventEntity> events;
  final int defaultIndex;

  const EventCarouselLoaded({
    this.events,
    this.defaultIndex = 0,
  }) : assert(defaultIndex >= 0, 'defaultIndex cannot be less than 0');

  @override
  List<Object> get props => [events, defaultIndex];
}