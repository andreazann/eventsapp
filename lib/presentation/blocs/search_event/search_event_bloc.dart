import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:eventsapp/domain/entities/app_error.dart';
import 'package:eventsapp/domain/entities/event_entity.dart';
import 'package:eventsapp/domain/entities/event_search_params.dart';
import 'package:eventsapp/domain/usecases/search_events.dart';

part 'search_event_event.dart';
part 'search_event_state.dart';

class SearchEventBloc extends Bloc<SearchEventEvent, SearchEventState> {
  final SearchEvents searchEvents;

  SearchEventBloc({
    @required this.searchEvents,
  }) : super(SearchEventInitial());

  @override
  Stream<SearchEventState> mapEventToState(
      SearchEventEvent event,
      ) async* {
    if (event is SearchTermChangedEvent) {
      if (event.searchTerm.length > 2) {
        yield SearchEventLoading();
        final Either<AppError, List<EventEntity>> response =
        await searchEvents(EventSearchParams(searchTerm: event.searchTerm));
        yield response.fold(
              (l) => SearchEventError(l.appErrorType),
              (r) => SearchEventLoaded(r),
        );
      }
    }
  }
}