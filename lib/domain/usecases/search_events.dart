import 'package:dartz/dartz.dart';
import 'package:eventsapp/domain/entities/app_error.dart';
import 'package:eventsapp/domain/entities/event_entity.dart';
import 'package:eventsapp/domain/entities/event_search_params.dart';
import 'package:eventsapp/domain/repositories/event_repository.dart';
import 'package:eventsapp/domain/usecases/usecase.dart';

class SearchEvents extends UseCase<List<EventEntity>, EventSearchParams> {
  final EventRepository repository;

  SearchEvents(this.repository);

  @override
  Future<Either<AppError, List<EventEntity>>> call(
      EventSearchParams searchParams) async {
    return await repository.getSearchedEvents(searchParams.searchTerm);
  }
}