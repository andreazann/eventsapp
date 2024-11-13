import 'package:flutter/material.dart';
import '../../../../domain/entities/event_entity.dart';
import '../../../widgets/event_app_bar.dart';
import '../../../widgets/separator.dart';

import 'event_backdrop_widget.dart';
import 'event_data_widget.dart';
import 'event_page_view.dart';

class EventCarouselWidget extends StatelessWidget {
  final List<EventEntity> events;
  final int defaultIndex;

  const EventCarouselWidget({
    Key key,
    @required this.events,
    @required this.defaultIndex,
  })  : assert(defaultIndex >= 0, 'defaultIndex cannot be less than 0'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        EventBackdropWidget(),
        Column(
          children: [
            EventAppBar(),
            EventPageView(
              events: events,
              initialPage: defaultIndex,
            ),
            EventDataWidget(),
            Separator(),
          ],
        ),
      ],
    );
  }
}