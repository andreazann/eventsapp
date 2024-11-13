import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:eventsapp/domain/entities/app_error.dart';
import 'package:eventsapp/domain/entities/event_detail_entity.dart';
import 'package:eventsapp/domain/entities/event_params.dart';
import 'package:eventsapp/domain/usecases/get_event_detail.dart';

part 'event_detail_event.dart';
part 'event_detail_state.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final GetEventDetail getEventDetail;

  EventDetailBloc({
    @required this.getEventDetail,
  }) : super(EventDetailInitial());

  @override
  Stream<EventDetailState> mapEventToState(
      EventDetailEvent event,
      ) async* {
    if (event is EventDetailLoadEvent) {
      final Either<AppError, EventDetailEntity> eitherResponse =
      await getEventDetail(
        EventParams(event.eventId),
      );

      yield eitherResponse.fold(
            (l) => EventDetailError(),
            (r) => EventDetailLoaded(r),
      );
    }
  }
}