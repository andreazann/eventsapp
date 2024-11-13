import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/navigation_bloc.dart';
import 'package:eventsapp/auth.dart';

class HomeScreen extends StatefulWidget with NavigationStates {
  final User currentUser;

  HomeScreen(this.currentUser);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.blue,
    elevation: 5.0,
    padding: EdgeInsets.all(15.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Flutter Firebase"),
        centerTitle: true,
        //actions: <Widget>[LogoutButton()],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Text(
              'Home Page Flutter Firebase  Content',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text(
              'Welcome ${widget.currentUser.email}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
                style: raisedButtonStyle,
                child: Text("LOGOUT"),
                onPressed: () async {
                  await Provider.of<AuthService>(context, listen: false)
                      .logout();

                  //Navigator.pushReplacementNamed(context, "/");
                })
          ],
        ),
      ),
    );
  }
}
