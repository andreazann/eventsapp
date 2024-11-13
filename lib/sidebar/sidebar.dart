import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';
import '../utilities/navigation_bloc.dart';
import '../sidebar/menu_item.dart';

class SideBar extends StatefulWidget {
  final User currentUser;

  SideBar(this.currentUser);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 500);

  //bool showClipper;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
    //showClipper = false;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data ? 0 : screenWidth - 45,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: const Color(0xFF151522), //Color(0xFF478DE0),
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          ListTile(
                            title: Text(
                              "${widget.currentUser.displayName}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                            subtitle: Text(
                              "${widget.currentUser.email}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            /*leading: CircleAvatar(
                              /*child: Icon(
                                Icons.perm_identity,
                                color: Colors.white,
                              ),*/
                              radius: 40,
                              backgroundColor: Color(0xFF1D4ED1),
                              backgroundImage: //AssetImage('assets/images/tree.jpg'),
                                  NetworkImage(
                                widget.currentUser.photoURL ?? '',
                              ),
                            ),*/
                          ),
                          Divider(
                            height: 64,
                            thickness: 0.5,
                            color: Colors.white.withOpacity(0.3),
                            indent: 32,
                            endIndent: 32,
                          ),
                          MenuItem(
                            icon: Icons.home,
                            title: "Home",
                            key: const Key('Home sidebar'),
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.HomePageClickedEvent);
                            },
                          ),
                          MenuItem(
                            icon: Icons.person,
                            title: "My Account",
                            key: const Key('My account sidebar'),
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.MyAccountClickedEvent);
                            },
                          ),
                          /*MenuItem(
                            icon: Icons.shopping_basket,
                            title: "My Orders",
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.MyOrdersClickedEvent);
                            },
                          ),*/
                          MenuItem(
                            icon: Icons.card_giftcard,
                            title: "Create event",
                            key: const Key('Create event sidebar'),
                            onTap: () {
                              onIconPressed();
                              if (!widget.currentUser.isAnonymous) {
                                BlocProvider.of<NavigationBloc>(context).add(
                                    NavigationEvents.EventCreationClickedEvent);
                              } else {
                                return _buildShowErrorDialog(context,
                                    "You must be logged in with a valid account to create an event");
                              }
                            },
                          ),
                          Divider(
                            height: 64,
                            thickness: 0.5,
                            color: Colors.white.withOpacity(0.3),
                            indent: 32,
                            endIndent: 32,
                          ),
                          MenuItem(
                            icon: Icons.settings,
                            title: "Settings",
                            key: const Key('Settings sidebar'),
                            onTap: () {
                              onIconPressed();
                              BlocProvider.of<NavigationBloc>(context)
                                  .add(NavigationEvents.SettingsClickedEvent);
                            },
                          ),
                          MenuItem(
                            icon: Icons.exit_to_app,
                            title: "Logout",
                            key: const Key('Logout sidebar'),
                            onTap: () async {
                              if (!widget.currentUser.isAnonymous &&
                                  widget.currentUser.providerData[0]
                                          .providerId ==
                                      "google.com") {
                                Provider.of<AuthService>(context,
                                        listen: false)
                                    .logoutWithGoogle();
                              } else {
                                Provider.of<AuthService>(context,
                                        listen: false)
                                    .logout();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.95),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    key: const Key('Clipper'),
                    child: Container(
                      width: 45,
                      height: 100,
                      color: Color(0xFF151522),
                      //Color(0xFF478DE0),
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.white, //Color(0xFF262AAA),
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future _buildShowErrorDialog(BuildContext context, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text('Error Message'),
          content: Text(_message),
          actions: <Widget>[
            TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 10, height / 2 - 20, width - 10,
        height / 2); //(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width - 10, height / 2 + 24, 15,
        height / 2 + 32); //(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
