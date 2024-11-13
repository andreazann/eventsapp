import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:eventsapp/common/constants/size_constants.dart';
import 'package:eventsapp/common/extensions/size_extensions.dart';
import 'package:eventsapp/presentation/journeys/event_detail/event_detail_arguments.dart';
import 'package:eventsapp/presentation/journeys/event_detail/event_detail_screen.dart';

class EventCardWidget extends StatelessWidget {
  final String eventId;
  final String posterPath;

  const EventCardWidget({
    Key key,
    @required this.eventId,
    @required this.posterPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 32,
      borderRadius: BorderRadius.circular(Sizes.dimen_16.w),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(
                eventDetailArguments: EventDetailArguments(eventId),
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.dimen_16.w),
          child: CachedNetworkImage(
            imageUrl: '$posterPath',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}