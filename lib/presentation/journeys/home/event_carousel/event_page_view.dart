import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constants/size_constants.dart';
import '../../../../common/extensions/size_extensions.dart';
import '../../../../common/screenutil/screenutil.dart';
import '../../../../domain/entities/event_entity.dart';
import '../../../blocs/event_backdrop/event_backdrop_bloc.dart';
import 'animated_event_card_widget.dart';

class EventPageView extends StatefulWidget {
  final List<EventEntity> events;
  final int initialPage;

  const EventPageView({
    Key key,
    @required this.events,
    @required this.initialPage,
  })  : assert(initialPage >= 0, 'initialPage cannot be less than 0'),
        super(key: key);

  @override
  _EventPageViewState createState() => _EventPageViewState();
}

class _EventPageViewState extends State<EventPageView> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.initialPage,
      keepPage: false,
      viewportFraction: 0.7,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Sizes.dimen_10.h),
      height: ScreenUtil.screenHeight * 0.25,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          final EventEntity event = widget.events[index];
          return AnimatedEventCardWidget(
            key: Key('eventCarouselCard$index'),
            index: index,
            pageController: _pageController,
            eventId: event.id,
            posterPath: event.imageUrl,
          );
        },
        pageSnapping: true,
        itemCount: widget.events?.length ?? 0,
        onPageChanged: (index) {
          BlocProvider.of<EventBackdropBloc>(context)
              .add(EventBackdropChangedEvent(widget.events[index]));
        },
      ),
    );
  }
}