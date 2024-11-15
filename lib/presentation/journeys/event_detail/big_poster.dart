import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:eventsapp/common/constants/size_constants.dart';
import 'package:eventsapp/common/screenutil/screenutil.dart';
import 'package:eventsapp/common/extensions/num_extensions.dart';
import 'package:eventsapp/common/extensions/size_extensions.dart';
import 'package:eventsapp/presentation/journeys/event_detail/event_detail_app_bar.dart';
import 'package:eventsapp/presentation/themes/theme_text.dart';
import 'package:eventsapp/data/core/api_constants.dart';
import 'package:eventsapp/domain/entities/event_detail_entity.dart';

class BigPoster extends StatelessWidget {
  final EventDetailEntity event;

  const BigPoster({
    Key key,
    @required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.3),
                Theme.of(context).primaryColor,
              ],
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: '${ApiConstants.BASE_IMAGE_URL}${event.imageUrl}',
            width: ScreenUtil.screenWidth,
            height: ScreenUtil.screenHeight*0.6,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ListTile(
            title: Text(
              event.title,
              style: Theme.of(context).textTheme.headline5,
            ),
            subtitle: Text(
              event.type,
              style: Theme.of(context).textTheme.greySubtitle1,
            ),
            trailing: Text(
              event.creator,
              style: Theme.of(context).textTheme.violetHeadline6,
            ),
          ),
        ),
        Positioned(
          left: Sizes.dimen_16.w,
          right: Sizes.dimen_16.w,
          top: ScreenUtil.statusBarHeight + Sizes.dimen_4.h,
          child: EventDetailAppBar(),
        ),
      ],
    );
  }
}