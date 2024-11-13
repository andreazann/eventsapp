import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:eventsapp/domain/usecases/get_event_detail.dart';
import '../presentation/blocs/event_backdrop/event_backdrop_bloc.dart';
import 'package:eventsapp/presentation/blocs/event_carousel/event_carousel_bloc.dart';
import 'package:eventsapp/presentation/blocs/event_detail/event_detail_bloc.dart';
import 'package:eventsapp/presentation/blocs/event_tabbed/event_tabbed_bloc.dart';
import 'package:eventsapp/presentation/blocs/search_event/search_event_bloc.dart';

import '../data/core/api_client.dart';
import '../data/data_sources/event_remote_data_source.dart';
import '../data/repositories/event_repository_impl.dart';
import '../domain/repositories/event_repository.dart';
import '../domain/usecases/search_events.dart';
import '../domain/usecases/get_coming_soon.dart';
import '../domain/usecases/get_playing_now.dart';
import '../domain/usecases/get_popular.dart';
import '../domain/usecases/get_trending.dart';

final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerLazySingleton<Client>(() => Client());

  getItInstance
      .registerLazySingleton<ApiClient>(() => ApiClient(getItInstance()));

  getItInstance.registerLazySingleton<EventRemoteDataSource>(
          () => EventRemoteDataSourceImpl(getItInstance()));

  getItInstance
      .registerLazySingleton<GetTrending>(() => GetTrending(getItInstance()));
  getItInstance
      .registerLazySingleton<GetPopular>(() => GetPopular(getItInstance()));
  getItInstance.registerLazySingleton<GetPlayingNow>(
          () => GetPlayingNow(getItInstance()));
  getItInstance.registerLazySingleton<GetComingSoon>(
          () => GetComingSoon(getItInstance()));

  getItInstance.registerLazySingleton<GetEventDetail>(
          () => GetEventDetail(getItInstance()));

  getItInstance
      .registerLazySingleton<SearchEvents>(() => SearchEvents(getItInstance()));

  getItInstance.registerLazySingleton<EventRepository>(
          () => EventRepositoryImpl(getItInstance()));

  getItInstance.registerFactory(() => EventBackdropBloc());

  getItInstance.registerFactory(
        () => EventCarouselBloc(
      getTrendingEvents: getItInstance(),
      eventBackdropBloc: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
        () => EventTabbedBloc(
      getPopularEvents: getItInstance(),
      getComingSoonEvents: getItInstance(),
      getPlayingNowEvents: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
        () => EventDetailBloc(
      getEventDetail: getItInstance(),
        ),
  );

  getItInstance.registerFactory(
        () => SearchEventBloc(
      searchEvents: getItInstance(),
    ),
  );

}