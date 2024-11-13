import 'package:eventsapp/utilities/navigation_bloc.dart';
import 'package:flutter/material.dart';
import '../common/screenutil/screenutil.dart';

import 'journeys/home/home_screen.dart';
import 'themes/theme_color.dart';
import 'themes/theme_text.dart';

class EventApp extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event App',
      theme: ThemeData(
        primaryColor: AppColor.vulcan,
        scaffoldBackgroundColor: AppColor.vulcan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: ThemeText.getTextTheme(),
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      home: HomeScreen(),
    );
  }
}