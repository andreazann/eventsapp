import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:eventsapp/common/constants/size_constants.dart';
import 'package:eventsapp/common/extensions/size_extensions.dart';
import 'package:eventsapp/common/extensions/string_extensions.dart';
import 'package:eventsapp/presentation/journeys/event_detail/event_detail_arguments.dart';
import 'package:eventsapp/presentation/journeys/event_detail/event_detail_screen.dart';

class EventTabCardWidget extends StatelessWidget {
  final String eventId;
  final String title, posterPath;

  const EventTabCardWidget({
    Key key,
    @required this.eventId,
    @required this.title,
    @required this.posterPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(
              eventDetailArguments: EventDetailArguments(eventId),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.dimen_16.w),
              child: CachedNetworkImage(
                imageUrl: '$posterPath',
                fit: BoxFit.cover,
                width: Sizes.dimen_200.w,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Sizes.dimen_4.h),
            child: Text(
              title.intelliTrim(),
              maxLines: 1,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}