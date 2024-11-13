import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/event_entity.dart';

part 'event_backdrop_event.dart';
part 'event_backdrop_state.dart';

class EventBackdropBloc extends Bloc<EventBackdropEvent, EventBackdropState> {
  EventBackdropBloc() : super(EventBackdropInitial());

  @override
  Stream<EventBackdropState> mapEventToState(
      EventBackdropEvent event,
      ) async* {
    yield EventBackdropChanged((event as EventBackdropChangedEvent).event);
  }
}