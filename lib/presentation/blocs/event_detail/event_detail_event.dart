part of 'event_detail_bloc.dart';

abstract class EventDetailEvent extends Equatable {
  const EventDetailEvent();
}

class EventDetailLoadEvent extends EventDetailEvent {
  final String eventId;

  const EventDetailLoadEvent(this.eventId);

  @override
  List<Object> get props => [eventId];
}