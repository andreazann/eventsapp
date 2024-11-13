import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  bool _isSigningIn = false;

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  ///
  /// return the Future with firebase user object FirebaseUser if one exists
  ///
  Future<User> getUser() {
    return Future.value(_auth.currentUser);
  }

  // wrapping the firebase calls
  void logout() async {
    //var result = FirebaseAuth.instance.signOut();
    FirebaseAuth.instance.signOut();
    notifyListeners();
    //return result;
  }

  // wrapping the firebase calls
  Future createUser(
      {String firstName,
      String lastName,
      String email,
      String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password).then((result) async {
            await result.user.updateDisplayName("$firstName $lastName");
            return result;
      });
      notifyListeners();
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return null;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  ///
  /// wrapping the firebase call to signInWithEmailAndPassword
  /// `email` String
  /// `password` String
  ///
  Future<User> loginUser({String email, String password}) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // since something changed, let's notify the listeners...
      notifyListeners();
      return result.user;
    } catch (e) {
      return null;
      throw new FirebaseAuthException(message: e.message, code: e.code);
    }
  }

  Future<void> forgetPasswordUser({String email}) async {
    String urlDyn = "https://evntapp.page.link/passwordReset";
    var actionCodeSettings = ActionCodeSettings(
      url: urlDyn,
      androidInstallApp: true,
      handleCodeInApp: true,
      androidPackageName: "com.example.eventsapp",
      iOSBundleId: "com.example.eventsapp",
      androidMinimumVersion: "21"
    );
    try {
      var result = await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email, actionCodeSettings: actionCodeSettings);
      // since something changed, let's notify the listeners...
      notifyListeners();
      return result;
    } catch (e) {
      print(e.toString());
      return null;
      throw new FirebaseAuthException(message: e.message, code: e.code);
    }
  }

  Future loginUserWithGoogle() async {
    isSigningIn = true;
    final user = await googleSignIn.signIn();
    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // Hide loading indicator
      isSigningIn = false;
      notifyListeners();
      return user;
    }
  }

  void logoutWithGoogle() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<User> loginAsGuest() async {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    notifyListeners();
    return userCredential.user;
  }
}
