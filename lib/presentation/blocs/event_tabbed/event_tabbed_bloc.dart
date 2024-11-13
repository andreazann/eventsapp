import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/event_entity.dart';
import '../../../domain/entities/no_params.dart';
import '../../../domain/usecases/get_coming_soon.dart';
import '../../../domain/usecases/get_playing_now.dart';
import '../../../domain/usecases/get_popular.dart';

part 'event_tabbed_event.dart';

part 'event_tabbed_state.dart';

class EventTabbedBloc extends Bloc<EventTabbedEvent, EventTabbedState> {
  final GetPopular getPopularEvents;
  final GetPlayingNow getPlayingNowEvents;
  final GetComingSoon getComingSoonEvents;

  EventTabbedBloc({
    @required this.getPopularEvents,
    @required this.getPlayingNowEvents,
    @required this.getComingSoonEvents,
  }) : super(EventTabbedInitial());

  @override
  Stream<EventTabbedState> mapEventToState(
      EventTabbedEvent event,
      ) async* {
    if (event is EventTabChangedEvent) {
      Either<AppError, List<EventEntity>> eventsEither;
      switch (event.currentTabIndex) {
        case 0:
          eventsEither = await getPopularEvents(NoParams());
          break;
        case 1:
          eventsEither = await getPlayingNowEvents(NoParams());
          break;
        case 2:
          eventsEither = await getComingSoonEvents(NoParams());
          break;
      }
      yield eventsEither.fold(
            (l) => EventTabLoadError(currentTabIndex: event.currentTabIndex),
            (events) {
          return EventTabChanged(
            currentTabIndex: event.currentTabIndex,
            events: events,
          );
        },
      );
    }
  }
}