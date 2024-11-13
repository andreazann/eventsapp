import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eventsapp/domain/entities/event_entity.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/no_params.dart';
import '../../../domain/usecases/get_trending.dart';
import '../event_backdrop/event_backdrop_bloc.dart';

part 'package:eventsapp/presentation/blocs/event_carousel/event_carousel_event.dart';
part 'package:eventsapp/presentation/blocs/event_carousel/event_carousel_state.dart';

class EventCarouselBloc extends Bloc<EventCarouselEvent, EventCarouselState> {
  final GetTrending getTrendingEvents;
  final EventBackdropBloc eventBackdropBloc;

  EventCarouselBloc({
    @required this.getTrendingEvents,
    @required this.eventBackdropBloc,
  }) : super(EventCarouselInitial());

  @override
  Stream<EventCarouselState> mapEventToState(
      EventCarouselEvent event,
      ) async* {
    if (event is CarouselLoadEvent) {
      final eventsEither = await getTrendingEvents(NoParams());
      yield eventsEither.fold(
            (l) => EventCarouselError(),
            (events) {
          eventBackdropBloc
              .add(EventBackdropChangedEvent(events[event.defaultIndex]));
          return EventCarouselLoaded(
            events: events,
            defaultIndex: event.defaultIndex,
          );
        },
      );
    }
  }
}