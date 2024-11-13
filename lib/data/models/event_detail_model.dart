import '../../domain/entities/event_detail_entity.dart';

class EventDetailModel extends EventDetailEntity {
  final String type;
  final String description;
  final String id;
  final String creator;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String title;
  final String videoUrl;

  EventDetailModel(
      {this.type,
        this.creator,
        this.imageUrl,
        this.videoUrl,
        this.latitude,
        this.longitude,
        this.description,
        this.id,
        this.title,})
      : super(
    id: id,
    title: title,
    creator: creator,
    type: type,
    latitude: latitude,
    longitude: longitude,
    imageUrl: imageUrl,
    videoUrl: videoUrl,
    description: description,
  );

  factory EventDetailModel.fromJson(Map<String, dynamic> json) {
    return EventDetailModel(
      type: json['type'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      description: json['description'],
      creator: json['creator'],
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['imageUrl'] = this.imageUrl;
    data['videoUrl'] = this.videoUrl;
    data['type'] = this.type;
    data['creator'] = this.creator;
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['title'] = this.title;
    return data;
  }
}