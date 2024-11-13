part of 'event_carousel_bloc.dart';

abstract class EventCarouselEvent extends Equatable {
  const EventCarouselEvent();

  @override
  List<Object> get props => [];
}

class CarouselLoadEvent extends EventCarouselEvent {
  final int defaultIndex;

  const CarouselLoadEvent({this.defaultIndex = 0})
      : assert(defaultIndex >= 0, 'defaultIndex cannot be less than 0');

  @override
  List<Object> get props => [defaultIndex];
}