import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/constants/size_constants.dart';
import '../../../../common/extensions/size_extensions.dart';
import '../../../../presentation/blocs/event_tabbed/event_tabbed_bloc.dart';
import '../../../../presentation/journeys/home/event_tabbed/tab_title_widget.dart';

import 'event_list_view_builder.dart';
import 'event_tabbed_constants.dart';

class EventTabbedWidget extends StatefulWidget {
  @override
  _EventTabbedWidgetState createState() => _EventTabbedWidgetState();
}

class _EventTabbedWidgetState extends State<EventTabbedWidget>
    with SingleTickerProviderStateMixin {
  EventTabbedBloc get eventTabbedBloc =>
      BlocProvider.of<EventTabbedBloc>(context);

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    eventTabbedBloc.add(EventTabChangedEvent(currentTabIndex: currentTabIndex));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventTabbedBloc, EventTabbedState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: Sizes.dimen_4.h),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /*for (var i = 0;
                  i < EventTabbedConstants.eventTabs.length;
                  i++)*/
                  TabTitleWidget(
                    key: const Key('allEventTabbedWidget'),
                    title: EventTabbedConstants.eventTabs[0].title,
                    onTap: () => _onTabTapped(0),
                    isSelected: EventTabbedConstants.eventTabs[0].index ==
                        state.currentTabIndex,
                  ),
                  TabTitleWidget(
                    key: const Key('brandEventTabbedWidget'),
                    title: EventTabbedConstants.eventTabs[1].title,
                    onTap: () => _onTabTapped(1),
                    isSelected: EventTabbedConstants.eventTabs[1].index ==
                        state.currentTabIndex,
                  ),
                  TabTitleWidget(
                    key: const Key('nearEventTabbedWidget'),
                    title: EventTabbedConstants.eventTabs[2].title,
                    onTap: () => _onTabTapped(2),
                    isSelected: EventTabbedConstants.eventTabs[2].index ==
                        state.currentTabIndex,
                  )
                ],
              ),
              if (state is EventTabChanged)
                Expanded(
                  child: EventListViewBuilder(events: state.events),
                ),
            ],
          ),
        );
      },
    );
  }

  void _onTabTapped(int index) {
    eventTabbedBloc.add(EventTabChangedEvent(currentTabIndex: index));
  }
}
