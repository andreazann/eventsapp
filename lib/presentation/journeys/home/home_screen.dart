import 'package:eventsapp/screens/coupon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../di/get_it.dart';
import '../../blocs/event_backdrop/event_backdrop_bloc.dart';
import 'package:eventsapp/presentation/blocs/event_carousel/event_carousel_bloc.dart';
import 'package:eventsapp/presentation/blocs/event_tabbed/event_tabbed_bloc.dart';
import 'package:eventsapp/presentation/blocs/search_event/search_event_bloc.dart';
import 'dart:math';

import 'event_carousel/event_carousel_widget.dart';
import 'event_tabbed/event_tabbed_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'video_list.dart';
import 'package:eventsapp/utilities/navigation_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget with NavigationStates {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  EventCarouselBloc eventCarouselBloc;
  EventBackdropBloc eventBackdropBloc;
  EventTabbedBloc eventTabbedBloc;
  SearchEventBloc searchEventBloc;
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;
  Future<SharedPreferences> _prefs;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  final List<String> _ids = [
    '1ItOwxKN8G8',
    'SY4Pl75BJPQ',
  ];

  @override
  void initState() {
    super.initState();
    eventCarouselBloc = getItInstance<EventCarouselBloc>();
    eventBackdropBloc = eventCarouselBloc.eventBackdropBloc;
    eventTabbedBloc = getItInstance<EventTabbedBloc>();
    searchEventBloc = getItInstance<SearchEventBloc>();
    eventCarouselBloc.add(CarouselLoadEvent());
    _prefs = SharedPreferences.getInstance();
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
        //hideControls: true,
        controlsVisibleAtStart: false,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    eventCarouselBloc?.close();
    eventBackdropBloc?.close();
    eventTabbedBloc?.close();
    searchEventBloc?.close();
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => eventCarouselBloc,
        ),
        BlocProvider(
          create: (context) => eventBackdropBloc,
        ),
        BlocProvider(
          create: (context) => eventTabbedBloc,
        ),
        BlocProvider(
          create: (context) => searchEventBloc,
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<EventCarouselBloc, EventCarouselState>(
          bloc: eventCarouselBloc,
          builder: (context, state) {
            if (state is EventCarouselLoaded) {
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  FractionallySizedBox(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.5,
                    child: EventCarouselWidget(
                      key: const Key('carouselWidgetFraction'),
                      events: state.events,
                      defaultIndex: state.defaultIndex,
                    ),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.5,
                    key: const Key('tabbedWidgetFraction'),
                    child: EventTabbedWidget(),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700];
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900];
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);

  Widget _loadCueButton(String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.blueAccent,
        onPressed: _isPlayerReady
            ? () {
                if (_idController.text.isNotEmpty) {
                  var id = YoutubePlayer.convertUrlToId(
                        _idController.text,
                      ) ??
                      '';
                  if (action == 'LOAD') _controller.load(id);
                  if (action == 'CUE') _controller.cue(id);
                  FocusScope.of(context).requestFocus(FocusNode());
                } else {
                  _showSnackBar('Source can\'t be empty!', null, null);
                }
              }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message, Duration videoLength, String brand) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        duration: Duration(seconds: 8),
        onVisible: () async {
          SharedPreferences prefs = await _prefs;
          Random random = new Random();
          List<String> coupons = [];
          String discount =
              (random.nextInt(10) + videoLength.inMinutes).toString();
          if (prefs.getKeys().contains(brand)) {
            coupons = prefs.getStringList(brand);
          }
          coupons.add(discount);
          prefs.setStringList(brand, coupons);
          print("Coupon added to user profile");
          print(prefs.get(brand));
        },
        shape:
            CouponShapeBorder(), /*RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),*/
      ),
    );
  }
}
