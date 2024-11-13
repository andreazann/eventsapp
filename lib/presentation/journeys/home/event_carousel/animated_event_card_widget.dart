import 'package:flutter/material.dart';
import '../../../../common/constants/size_constants.dart';
import '../../../../common/extensions/size_extensions.dart';
import '../../../../common/screenutil/screenutil.dart';

import 'event_card_widget.dart';

class AnimatedEventCardWidget extends StatelessWidget {
  final int index;
  final String eventId;
  final String posterPath;
  final PageController pageController;

  const AnimatedEventCardWidget({
    Key key,
    @required this.index,
    @required this.eventId,
    @required this.posterPath,
    @required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        double value = 1;
        if (pageController.position.haveDimensions) {
          value = pageController.page - index;
          value = (1 - (value.abs() * 0.1)).clamp(0.0, 1.0);
          return Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: Curves.easeIn.transform(value) *
                  ScreenUtil.screenHeight *
                  0.35,
              width: Sizes.dimen_230.w,
              child: child,
            ),
          );
        } else {
          return Align(
            alignment: Alignment.topCenter,
            child: Container(
              height:
              Curves.easeIn.transform(index == 0 ? value : value * 0.5) *
                  ScreenUtil.screenHeight *
                  0.35,
              width: Sizes.dimen_230.w,
              child: child,
            ),
          );
        }
      },
      child: EventCardWidget(
        eventId: eventId,
        posterPath: posterPath,
      ),
    );
  }
}