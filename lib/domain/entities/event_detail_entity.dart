import 'package:equatable/equatable.dart';

class EventDetailEntity extends Equatable {
  final String id;
  final String title;
  final String type;
  final String creator;
  final double latitude;
  final double longitude;
  final String description;
  final String imageUrl;
  final String videoUrl;

  const EventDetailEntity({
    this.id,
    this.title,
    this.creator,
    this.imageUrl,
    this.description,
    this.latitude,
    this.longitude,
    this.type,
    this.videoUrl,
  });

  @override
  List<Object> get props => [id];
}