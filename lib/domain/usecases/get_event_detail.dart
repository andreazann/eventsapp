import 'package:dartz/dartz.dart';
import 'package:eventsapp/domain/entities/app_error.dart';
import 'package:eventsapp/domain/entities/event_detail_entity.dart';
import 'package:eventsapp/domain/entities/event_params.dart';
import 'package:eventsapp/domain/repositories/event_repository.dart';
import 'package:eventsapp/domain/usecases/usecase.dart';

class GetEventDetail extends UseCase<EventDetailEntity, EventParams> {
  final EventRepository repository;

  GetEventDetail(this.repository);

  @override
  Future<Either<AppError, EventDetailEntity>> call(
      EventParams eventParams) async {
    return await repository.getEventDetail(eventParams.id);
  }
}