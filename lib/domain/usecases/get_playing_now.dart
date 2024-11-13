import '../repositories/event_repository.dart';
import '../entities/event_entity.dart';
import '../entities/app_error.dart';
import '../entities/no_params.dart';
import './usecase.dart';
import 'package:dartz/dartz.dart';


class GetPlayingNow extends UseCase<List<EventEntity>, NoParams> {
  final EventRepository repository;

  GetPlayingNow(this.repository);

  @override
  Future<Either<AppError, List<EventEntity>>> call(NoParams noParams) async {
    return await repository.getPlayingNowEvents();
  }
}