import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class EventEntity extends Equatable {
  final String imageUrl;
  final String id;
  final String creator;
  final String title;
  final double latitude;
  final double longitude;
  final String description;
  final String type;
  final String videoUrl;

  const EventEntity({
    @required this.imageUrl,
    @required this.videoUrl,
    @required this.id,
    @required this.creator,
    @required this.title,
    @required this.latitude,
    @required this.longitude,
    @required this.description,
    this.type,
  }) : assert(id != null, 'Event id must not be null');

  @override
  List<Object> get props => [id, title];

  @override
  bool get stringify => true;
}