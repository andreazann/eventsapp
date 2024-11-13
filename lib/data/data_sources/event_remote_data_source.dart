import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventsapp/data/models/event_result_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/api_client.dart';
import '../models/event_result_model.dart';
import '../models/event_detail_model.dart';

import '../models/event_model.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getTrendingEvents();
  Future<List<EventModel>> getPopularEvents();
  Future<List<EventModel>> getPlayingNowEvents();
  Future<List<EventModel>> getComingSoonEvents();
  Future<List<EventModel>> getSearchedEvents(String searchTerm);
  Future<EventDetailModel> getEventDetail(String id);
}

class EventRemoteDataSourceImpl extends EventRemoteDataSource {
  final ApiClient _client;

  EventRemoteDataSourceImpl(this._client);

  @override
  Future<List<EventModel>> getTrendingEvents() async {
    final response = await _client.getLatest();
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
    PermissionStatus stat = await Permission.location.request();
    print(stat);
    if (stat.isGranted) {
      var positionLatLng = await GeolocatorPlatform.instance
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      GeoPoint position = GeoPoint(positionLatLng.latitude, positionLatLng.longitude);
      final response = await _client.getNear(position);
      final events = EventsResultModel.fromJson(response).events;
      print(events);
      return events;
    } else {
      print("no location permission");
      openAppSettings();
      //Geolocator.openAppSettings();
      //Geolocator.openLocationSettings();
      return [];
    }
    /*var positionLatLng = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    GeoPoint position = GeoPoint(positionLatLng.latitude, positionLatLng.longitude);
    final response = await _client.getNear(position);
    final events = EventsResultModel.fromJson(response).events;
    print(events);
    return events;*/
  }

  @override
  Future<List<EventModel>> getPlayingNowEvents() async {
    final response = await _client.getBranded();
    final events = EventsResultModel.fromJson(response).events;
    print(events);
    return events;
  }

  @override
  Future<EventDetailModel> getEventDetail(String id) async {
    final response = await _client.getDetail(id);
    final event = EventDetailModel.fromJson(response);
    print(event);
    return event;
  }

  @override
  Future<List<EventModel>> getSearchedEvents(String searchTerm) async {
    final response = await _client.getSearched(searchTerm);
    final events = EventsResultModel.fromJson(response).events;
    print(events);
    return events;
  }
}