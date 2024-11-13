import 'package:equatable/equatable.dart';

class EventParams extends Equatable {
  final String id;

  const EventParams(this.id);

  @override
  List<Object> get props => [id];
}