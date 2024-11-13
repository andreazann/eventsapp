import 'package:dartz/dartz.dart';
import '../entities/app_error.dart';
import '../entities/event_detail_entity.dart';
import '../entities/event_entity.dart';

abstract class EventRepository {
  Future<Either<AppError, List<EventEntity>>> getTrendingEvents();
  Future<Either<AppError, List<EventEntity>>> getPopularEvents();
  Future<Either<AppError, List<EventEntity>>> getPlayingNowEvents();
  Future<Either<AppError, List<EventEntity>>> getComingSoonEvents();
  Future<Either<AppError, EventDetailEntity>> getEventDetail(String id);
  Future<Either<AppError, List<EventEntity>>> getSearchedEvents(
      String searchTerm);
}