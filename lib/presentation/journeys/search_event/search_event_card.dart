import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:eventsapp/common/constants/size_constants.dart';
import 'package:eventsapp/data/core/api_constants.dart';
import 'package:eventsapp/common/extensions/size_extensions.dart';
import 'package:eventsapp/presentation/themes/theme_text.dart';
import 'package:eventsapp/domain/entities/event_entity.dart';
import 'package:eventsapp/presentation/journeys/event_detail/event_detail_arguments.dart';
import 'package:eventsapp/presentation/journeys/event_detail/event_detail_screen.dart';

class SearchEventCard extends StatelessWidget {
  final EventEntity event;

  const SearchEventCard({
    Key key,
    @required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(
              eventDetailArguments: EventDetailArguments(event.id),
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.dimen_16.w,
          vertical: Sizes.dimen_2.h,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(Sizes.dimen_8.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Sizes.dimen_4.w),
                child: CachedNetworkImage(
                  imageUrl: '${ApiConstants.BASE_IMAGE_URL}${event.imageUrl}',
                  width: Sizes.dimen_80.w,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    event.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.greyCaption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}