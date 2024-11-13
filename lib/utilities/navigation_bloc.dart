import 'package:bloc/bloc.dart';
import '../screens/myaccountspage.dart';
import '../screens/myorderspage.dart';
import '../screens/event_creation.dart';
import '../presentation/journeys/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/settings_screen.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  MyAccountClickedEvent,
  MyOrdersClickedEvent,
  EventCreationClickedEvent,
  SettingsClickedEvent,

}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationStates initState;
  User currentUser;
  NavigationBloc(NavigationStates initialState, User currentUser) : super(initialState) {
    this.initState = initialState;
    this.currentUser = currentUser;
  }

  //@override
  //NavigationStates get initialState => MyAccountsPage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield HomeScreen();
        break;
      case NavigationEvents.MyAccountClickedEvent:
        yield MyAccountsPage();
        break;
      case NavigationEvents.MyOrdersClickedEvent:
        yield MyOrdersPage();
        break;
      case NavigationEvents.EventCreationClickedEvent:
        yield EventCreationPage(this.currentUser);
        break;
      case NavigationEvents.SettingsClickedEvent:
        yield SettingsScreen(this.currentUser);
        break;
    }
  }
}
