import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import '../utilities/navigation_bloc.dart';
import 'sidebar.dart';

import 'package:pedantic/pedantic.dart';
import '../di/get_it.dart' as getIt;
import '../presentation/event_app.dart';


class SideBarLayout extends StatelessWidget {
  final User currentUser;
  SideBarLayout(this.currentUser);

  //NavigationStates get initialState => HomeScreen(currentUser);
  NavigationStates get initialState {
    if(!getIt.getItInstance.isRegistered(instance: Client)) {
      unawaited(getIt.init());
    }
    return EventApp();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NavigationBloc>(
        create: (context) => NavigationBloc(initialState, currentUser),
        child: Stack(
          children: <Widget>[
            BlocBuilder<NavigationBloc, NavigationStates>(
              builder: (context, navigationState) {
                return navigationState as Widget;
              },
            ),
            SideBar(currentUser),
          ],
        ),
      ),
    );
  }
}
