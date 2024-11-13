import './event_model.dart';

class EventsResultModel {
  List<EventModel> events;

  EventsResultModel({this.events});

  EventsResultModel.fromJson(Map<String, dynamic> json) {
    if(json != null) {
      if (json['results'] != null) {
        events = new List<EventModel>();
        json['results'].forEach((v) {
          events.add(EventModel.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.events != null) {
      data['results'] = this.events.map((v) => v.toJson()).toList();
    }
    return data;
  }
}