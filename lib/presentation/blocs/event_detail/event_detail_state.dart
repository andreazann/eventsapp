part of 'event_detail_bloc.dart';

abstract class EventDetailState extends Equatable {
  const EventDetailState();

  @override
  List<Object> get props => [];
}

class EventDetailInitial extends EventDetailState {}

class EventDetailLoading extends EventDetailState {}

class EventDetailError extends EventDetailState {}

class EventDetailLoaded extends EventDetailState {
  final EventDetailEntity eventDetailEntity;

  const EventDetailLoaded(this.eventDetailEntity);

  @override
  List<Object> get props => [eventDetailEntity];
}