import 'package:eventsapp/presentation/themes/theme_color.dart';
import 'package:eventsapp/presentation/themes/theme_text.dart';
import 'package:eventsapp/utilities/dynamicLinksHandler.dart';
import 'package:flutter/material.dart';
import 'package:eventsapp/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'auth.dart';
import 'sidebar/sidebar_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider<AuthService>(
      child: App(),
      create: (BuildContext context) {
        return AuthService();
      },
    ),
  ); //runApp(MyApp());
}

class App extends StatefulWidget {
  MyApp createState() => MyApp();
}

class MyApp extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  DynamicLinkService _dynamicLinkService = DynamicLinkService();

  final LocalAuthentication localAuth = LocalAuthentication();
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool _isAuthenticated = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    handleStartUpLogic();
  }

  Future handleStartUpLogic() async {
    // call handle dynamic links
    await _dynamicLinkService.handleDynamicLinks();
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('fingerprint'));
    if ((prefs.getBool('fingerprint') ?? false)){
      await _authenticateWithBiometrics();
    } else {
      setState(() {
        _isAuthenticated = true;
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Show error message if initialization failed
    if(_error) {
      return AlertDialog(
        title: Text('Error Message'),
        content: Text("Initialization failed"),
        actions: <Widget>[
          TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      );
    }

    // Show a loader until FlutterFire is initialized and fingerprint authentication is not terminated
    if (!_initialized || !_isAuthenticated) {
      return LoadingCircle();
    }
    return MaterialApp(
      title: 'Eventsapp',
      theme: ThemeData(
        primaryColor: AppColor.vulcan,
        scaffoldBackgroundColor: AppColor.vulcan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: ThemeText.getTextTheme(),
        appBarTheme: const AppBarTheme(elevation: 0),
        pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }
        )
      ),
      debugShowCheckedModeBanner: false,
      //home: LoginScreen(),
      home: FutureBuilder<User>( //FutureBuilder<User>
        future:Provider.of<AuthService>(context).getUser() ,
        builder: (context, AsyncSnapshot<User> snapshot) { //AsyncSnapshot<User>
          if (snapshot.connectionState == ConnectionState.done) {
            // log error to console
            if (snapshot.error != null) {
              print("error");
              return Text(snapshot.error.toString());
            }

            // redirect to the proper page
            if(snapshot.hasData){
              //unawaited(getIt.init());
              //return MovieApp();
              return SideBarLayout(snapshot.data);
            } else {
              return LoginScreen();
            }
          } else {
            // show loading indicator
            return LoadingCircle();
          }
        },
      ),
    );
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await localAuth.authenticate(
          localizedReason:
          'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
        _isAuthenticated = true;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }
}

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: CircularProgressIndicator(),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}
