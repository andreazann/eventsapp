import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class EventSearchParams extends Equatable {
  final String searchTerm;

  EventSearchParams({@required this.searchTerm});

  @override
  List<Object> get props => [searchTerm];
}