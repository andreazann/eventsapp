import '../../domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  final String id;
  final double latitude;
  final double longitude;
  final String title;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final String type;
  final String creator;

  EventModel({
    this.id,
    this.longitude,
    this.latitude,
    this.title,
    this.description,
    this.imageUrl,
    this.videoUrl,
    this.type,
    this.creator,
  }) : super(
    id: id,
    title: title,
    imageUrl: imageUrl,
    videoUrl: videoUrl,
    creator: creator,
    description: description,
    latitude: latitude,
    longitude: longitude,
    type: type,
  );

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      creator: json['creator'],
      id: json['id'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['title'] = this.title;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    data['videoUrl'] = this.videoUrl;
    data['creator'] = this.creator;
    data['type'] = this.type;
    return data;
  }
}