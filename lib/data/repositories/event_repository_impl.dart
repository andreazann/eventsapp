import 'dart:io';

import '../data_sources/event_remote_data_source.dart';
import '../../domain/repositories/event_repository.dart';
import '../models/event_detail_model.dart';
import '../models/event_model.dart';
import '../../domain/entities/app_error.dart';
import 'package:dartz/dartz.dart';

class EventRepositoryImpl extends EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<AppError, List<EventModel>>> getTrendingEvents() async {
    try {
      final events = await remoteDataSource.getTrendingEvents();
      return Right(events);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, List<EventModel>>> getComingSoonEvents() async {
    try {
      final events = await remoteDataSource.getComingSoonEvents();
      return Right(events);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, List<EventModel>>> getPlayingNowEvents() async {
    try {
      final events = await remoteDataSource.getPlayingNowEvents();
      return Right(events);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, List<EventModel>>> getPopularEvents() async {
    try {
      final events = await remoteDataSource.getPopularEvents();
      return Right(events);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, EventDetailModel>> getEventDetail(String id) async {
    try {
      final event = await remoteDataSource.getEventDetail(id);
      return Right(event);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, List<EventModel>>> getSearchedEvents(
      String searchTerm) async {
    try {
      final events = await remoteDataSource.getSearchedEvents(searchTerm);
      return Right(events);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.api));
    }
  }
}