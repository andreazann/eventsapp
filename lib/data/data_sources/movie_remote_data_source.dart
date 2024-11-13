import 'package:eventsapp/data/models/event_result_model.dart';

import '../core/api_client.dart';
import '../models/movies_result_model.dart';
import '../models/movie_detail_model.dart';
import '../models/event_result_model.dart';
import '../models/event_detail_model.dart';

import '../models/movie_model.dart';
import '../models/event_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getTrending();
  Future<List<MovieModel>> getPopular();
  Future<List<MovieModel>> getPlayingNow();
  Future<List<MovieModel>> getComingSoon();
  Future<List<MovieModel>> getSearchedMovies(String searchTerm);
  Future<MovieDetailModel> getMovieDetail(int id);
  Future<List<EventModel>> getTrendingEvents();
  Future<List<EventModel>> getPopularEvents();
  Future<List<EventModel>> getPlayingNowEvents();
  Future<List<EventModel>> getComingSoonEvents();
  Future<List<EventModel>> getSearchedEvents(String searchTerm);
  Future<EventDetailModel> getEventDetail(String id);
}

class MovieRemoteDataSourceImpl extends MovieRemoteDataSource {
  final ApiClient _client;

  MovieRemoteDataSourceImpl(this._client);

  @override
  Future<List<EventModel>> getTrendingEvents() async {
    final response = await _client.get('trending/movie/day');
    final events = EventsResultModel.fromJson(response).events;
    print(events);
    return events;
  }

  @override
  Future<List<EventModel>> getPopularEvents() async {
    final response = await _client.get('movie/popular');
    final events = EventsResultModel.fromJson(response).events;
    print(events);
    return events;
  }

  @override
  Future<List<EventModel>> getComingSoonEvents() async {
    final response = await _client.get('movie/upcoming');
    final events = EventsResultModel.fromJson(response).events;
    print(events);
    return events;
  }

  @override
  Future<List<EventModel>> getPlayingNowEvents() async {
    final response = await _client.get('movie/now_playing');
    final events = EventsResultModel.fromJson(response).events;
    print(events);
    return events;
  }

  @override
  Future<EventDetailModel> getEventDetail(String id) async {
    final response = await _client.get('movie/$id');
    final event = EventDetailModel.fromJson(response);
    print(event);
    return event;
  }

  @override
  Future<List<EventModel>> getSearchedEvents(String searchTerm) async {
    final response = await _client.get('search/movie', params: {
      'query': searchTerm,
    });
    final events = EventsResultModel.fromJson(response).events;
    print(events);
    return events;
  }

  @override
  Future<List<MovieModel>> getTrending() async {
    final response = await _client.get('trending/movie/day');
    final movies = MoviesResultModel.fromJson(response).movies;
    print(movies);
    return movies;
  }

  @override
  Future<List<MovieModel>> getPopular() async {
    final response = await _client.get('movie/popular');
    final movies = MoviesResultModel.fromJson(response).movies;
    print(movies);
    return movies;
  }

  @override
  Future<List<MovieModel>> getComingSoon() async {
    final response = await _client.get('movie/upcoming');
    final movies = MoviesResultModel.fromJson(response).movies;
    print(movies);
    return movies;
  }

  @override
  Future<List<MovieModel>> getPlayingNow() async {
    final response = await _client.get('movie/now_playing');
    final movies = MoviesResultModel.fromJson(response).movies;
    print(movies);
    return movies;
  }

  @override
  Future<MovieDetailModel> getMovieDetail(int id) async {
    final response = await _client.get('movie/$id');
    final movie = MovieDetailModel.fromJson(response);
    print(movie);
    return movie;
  }

  @override
  Future<List<MovieModel>> getSearchedMovies(String searchTerm) async {
    final response = await _client.get('search/movie', params: {
      'query': searchTerm,
    });
    final movies = MoviesResultModel.fromJson(response).movies;
    print(movies);
    return movies;
  }
}