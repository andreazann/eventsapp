import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventsapp/common/constants/size_constants.dart';
import 'package:eventsapp/common/extensions/size_extensions.dart';
import 'package:eventsapp/di/get_it.dart';
import 'package:eventsapp/presentation/blocs/event_detail/event_detail_bloc.dart';
import 'package:eventsapp/presentation/journeys/event_detail/event_detail_arguments.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';
import 'package:eventsapp/screens/coupon.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';
import '../home/video_list.dart';
import 'package:flutter/services.dart';
import 'package:eventsapp/auth.dart';

class EventDetailScreen extends StatefulWidget {
  final EventDetailArguments eventDetailArguments;

  const EventDetailScreen({
    Key key,
    @required this.eventDetailArguments,
  })  : assert(eventDetailArguments != null, 'arguments must not be null'),
        super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  EventDetailBloc _eventDetailBloc;
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;
  Future<SharedPreferences> _prefs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  GoogleMapController mapController;

  //final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  bool _isSnackbarAlreadyVisible = false;

  final Map<String, String> _ids = {
    //'Barilla': '1ItOwxKN8G8',
    'Nike': 'SY4Pl75BJPQ',
  };

  @override
  void initState() {
    super.initState();
    _eventDetailBloc = getItInstance<EventDetailBloc>();
    _eventDetailBloc.add(
      EventDetailLoadEvent(
        widget.eventDetailArguments.eventId,
      ),
    );
    _prefs = SharedPreferences.getInstance();
    _controller = YoutubePlayerController(
      initialVideoId: 'AjWfY7SnMBI',
      // Black screen video for loading purposes //_ids.values.first,//.first,
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
    //SideBar.;
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
    _eventDetailBloc?.close();
    super.dispose();
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Scaffold(
        body: BlocProvider<EventDetailBloc>.value(
          value: _eventDetailBloc,
          child: BlocBuilder<EventDetailBloc, EventDetailState>(
            builder: (context, state) {
              if (state is EventDetailLoaded) {
                final eventDetail = state.eventDetailEntity;
                final Map<String, Marker> _markers = {};
                _markers['eventLocation'] = Marker(
                  markerId: MarkerId(eventDetail.title),
                  position: LatLng(eventDetail.latitude, eventDetail.longitude),
                  infoWindow: InfoWindow(
                    title: eventDetail.title,
                    snippet: eventDetail.description,
                  ),
                );
                return Stack(
                  //mainAxisSize: MainAxisSize.min,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  fit: StackFit.expand,
                  children: [
                    /*BigPoster(
                    event: eventDetail,
                  ),*/
                    FractionallySizedBox(
                      alignment: Alignment.topCenter,
                      heightFactor:
                          eventDetail.videoUrl == 'No video' ? 0.5 : 0.8,
                      child: eventDetail.videoUrl == 'No video'
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: GoogleMap(
                                key: const Key('googleMapsEventDetailWidget'),
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(eventDetail.latitude,
                                      eventDetail.longitude),
                                  zoom: 11.0,
                                ),
                                markers: _markers.values.toSet(),
                              ),
                            )
                          : YoutubePlayerBuilder(
                              key: const Key('youtubePlayerEventDetailWidget'),
                              onExitFullScreen: () {
                                // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                                SystemChrome.setPreferredOrientations(
                                    DeviceOrientation.values);
                              },
                              player: YoutubePlayer(
                                controller: _controller,
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: Colors.blueAccent,
                                topActions: <Widget>[
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      _controller.metadata.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                                bottomActions: [],
                                onReady: () {
                                  _isPlayerReady = true;
                                  //print(eventDetail.title);
                                  try {
                                    //https://www.youtube.com/watch?v=ofTb57aZHZs example url of video
                                    _controller.load(eventDetail.videoUrl
                                            .split('?v=')[
                                        1]); //_controller.load(_ids[eventDetail.title]);
                                  } catch (e) {
                                    _controller.load(_ids.values.first);
                                  }
                                  //_controller.load(_ids[eventDetail.title]);
                                },
                                onEnded: (data) {
                                  _showSnackBar('Here comes the coupon',
                                      data.duration, data.author);
                                  _controller.pause();
                                },
                              ),
                              builder: (context, player) => Scaffold(
                                appBar: AppBar(
                                  leading: IconButton(
                                    key: const Key('pageBack'),
                                    icon: Icon(Icons.arrow_back,
                                        color: Colors.white),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  title: Text(
                                    _controller.metadata.title,
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  centerTitle: true,
                                  /*actions: [
                                    IconButton(
                                      icon: const Icon(Icons.video_library),
                                      onPressed: () => Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => VideoList(),
                                        ),
                                      ),
                                    ),
                                  ],*/
                                ),
                                body: ListView(
                                  children: [
                                    player,
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          _space,
                                          _text('Title', _videoMetaData.title),
                                          _space,
                                          _text(
                                              'Channel', _videoMetaData.author),
                                          _space,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              IconButton(
                                                color: Colors.white,
                                                icon: Icon(
                                                  _controller.value.isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                ),
                                                onPressed: _isPlayerReady
                                                    ? () {
                                                        _controller
                                                                .value.isPlaying
                                                            ? _controller
                                                                .pause()
                                                            : _controller
                                                                .play();
                                                        setState(() {});
                                                      }
                                                    : null,
                                              ),
                                              IconButton(
                                                color: Colors.white,
                                                icon: Icon(_muted
                                                    ? Icons.volume_off
                                                    : Icons.volume_up),
                                                onPressed: _isPlayerReady
                                                    ? () {
                                                        _muted
                                                            ? _controller
                                                                .unMute()
                                                            : _controller
                                                                .mute();
                                                        setState(() {
                                                          _muted = !_muted;
                                                        });
                                                      }
                                                    : null,
                                              ),
                                              /*FullScreenButton(
                                                controller: _controller,
                                                color: Colors.white,
                                              ),*/
                                            ],
                                          ),
                                          _space,
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                "Volume",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Expanded(
                                                child: Slider(
                                                  activeColor: Colors.white,
                                                  inactiveColor:
                                                      Colors.transparent,
                                                  value: _volume,
                                                  min: 0.0,
                                                  max: 100.0,
                                                  divisions: 10,
                                                  label: '${(_volume).round()}',
                                                  onChanged: _isPlayerReady
                                                      ? (value) {
                                                          setState(() {
                                                            _volume = value;
                                                          });
                                                          _controller.setVolume(
                                                              _volume.round());
                                                        }
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.bottomCenter,
                      heightFactor:
                          eventDetail.videoUrl == 'No video' ? 0.5 : 0.35,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.dimen_16.w,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              eventDetail.title,
                              key: const Key('eventTitleEventDetailText'),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5, /*TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontSize: 30.0,
                              ),*/
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              eventDetail.description,
                              key: const Key('eventDescriptionEventDetailText'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2, /*TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontSize: 15.0,
                              ),*/
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is EventDetailError) {
                return Container();
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);

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
        duration: Duration(seconds: 5),
        onVisible: () async {
          if (_isSnackbarAlreadyVisible) {
            return;
          } else {
            _isSnackbarAlreadyVisible = true;
          }
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

          User currentUser =
              await Provider.of<AuthService>(context, listen: false).getUser();
          CollectionReference userCoupons = FirebaseFirestore.instance
              .collection('coupons')
              .doc(currentUser.uid)
              .collection(brand);
          userCoupons.add({
            'creator': currentUser.uid,
            'brand': brand,
            'coupon': discount
          }).then((event) {
            print("Event Added: $event");
          }).catchError((error) => print("Failed to add coupon: $error"));
          _isSnackbarAlreadyVisible = false;
        },
        shape:
            CouponShapeBorder(), /*RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),*/
      ),
    );
  }
}
