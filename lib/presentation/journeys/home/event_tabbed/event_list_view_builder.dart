import 'package:flutter/material.dart';
import '../../../../domain/entities/event_entity.dart';
import '../../../../common/extensions/size_extensions.dart';

import 'event_tab_card_widget.dart';

class EventListViewBuilder extends StatelessWidget {
  //1
  final List<EventEntity> events;

  const EventListViewBuilder({Key key, @required this.events})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: events.length > 0 ? events.length : 1,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 14.w,
          );
        },
        itemBuilder: (context, index) {
          if(events.length == 0){
            return AlertDialog(
              backgroundColor: Colors.black,
              title: Text('Info Message'),
              content: Text('No events near your location'),
              /*actions: <Widget>[
                TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      return null;
                    })
              ],*/
            );
          } else {
            final EventEntity event = events[index];
            return EventTabCardWidget(
              key: Key('eventCardWidget$index'),
              eventId: event.id,
              title: event.title,
              posterPath: event.imageUrl,
            );
          }
        },
      ),
    );
  }
}