import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/common/constants/size_constants.dart';
import 'package:eventsapp/common/constants/translation_constants.dart';
import 'package:eventsapp/common/extensions/string_extensions.dart';
import 'package:eventsapp/domain/entities/app_error.dart';
import 'package:eventsapp/presentation/blocs/search_event/search_event_bloc.dart';
import 'package:eventsapp/presentation/journeys/search_event/search_event_card.dart';
import 'package:eventsapp/presentation/themes/theme_color.dart';
import 'package:eventsapp/presentation/themes/theme_text.dart';
import 'package:eventsapp/common/extensions/size_extensions.dart';
import 'package:eventsapp/presentation/widgets/app_error_widget.dart';

class CustomSearchDelegate extends SearchDelegate {
  final SearchEventBloc searchEventBloc;

  CustomSearchDelegate(this.searchEventBloc);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: Theme.of(context).textTheme.greySubtitle1,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: query.isEmpty ? Colors.grey : AppColor.royalBlue,
        ),
        onPressed: query.isEmpty ? null : () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
        size: Sizes.dimen_12.h,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchEventBloc.add(
      SearchTermChangedEvent(query),
    );

    return BlocBuilder<SearchEventBloc, SearchEventState>(
      bloc: searchEventBloc,
      builder: (context, state) {
        if (state is SearchEventError) {
          return AppErrorWidget(
            errorType: state.errorType,
            onPressed: () =>
                searchEventBloc?.add(SearchTermChangedEvent(query)),
          );
        } else if (state is SearchEventLoaded) {
          final events = state.events;
          if (events.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_64.w),
                child: Text(
                  TranslationConstants.noEventsSearched.t(context),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) => SearchEventCard(
              event: events[index],
            ),
            itemCount: events.length,
            scrollDirection: Axis.vertical,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox.shrink();
  }
}