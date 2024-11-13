import 'package:eventsapp/utilities/constants.dart';
import 'package:eventsapp/utilities/navigation_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'languages_screen.dart';

class SettingsScreen extends StatefulWidget with NavigationStates {
  final User currentUser;

  SettingsScreen(this.currentUser);

  @override
  _SettingsScreenState createState() => _SettingsScreenState(currentUser);
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  bool fingerprintIsAbilitated = false;
  Color iconColor = Color(0xFF1D4ED1);
  String languageSelected = 'English';

  final LocalAuthentication localAuth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  final _formKey = GlobalKey<FormState>();

  String userCurrentPwd = '';
  String userNewPwdFirstInsert = '';
  String userNewPwdSecondInsert = '';

  Pattern _passwordPattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

  final User currentUser;

  _SettingsScreenState(this.currentUser);

  @override
  void initState() {
    super.initState();
    localAuth.isDeviceSupported().then(
          (isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    _checkBiometrics();
    _getAvailableBiometrics();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fingerprintIsAbilitated = (prefs.getBool('fingerprint') ?? false);
    });
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await localAuth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
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

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
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
              'Scan your fingerprint (or face or whatever) to authenticate',
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
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

  void _cancelAuthentication() async {
    await localAuth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          key: const Key('settingsTitle'),
        ),
        centerTitle: true,
      ),
      body: buildSettingsList(),
      backgroundColor: Color(0xFF151522),
    );
  }

  Widget buildSettingsList() {
    return SettingsList(
      backgroundColor: Color(0xFF151522),
      sections: [
        SettingsSection(
          title: 'Common',
          titlePadding: EdgeInsets.only(top: 20, left: 15),
          tiles: [
            SettingsTile(
              title: 'Language',
              subtitle: languageSelected,
              subtitleTextStyle: TextStyle(
                color: Colors.white,
              ),
              leading: Icon(
                Icons.language,
                color: iconColor,
              ),
              onPressed: (context) async {
                final result =
                    await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LanguagesScreen(
                    selectedLanguage: languageSelected,
                  ),
                ));
                setState(() {
                  languageSelected = result;
                });
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'Account',
          tiles: [
            SettingsTile(
              title: currentUser.phoneNumber != null
                  ? (currentUser.phoneNumber.isNotEmpty
                      ? currentUser.phoneNumber
                      : 'No phone number provided')
                  : 'No phone number provided',
              leading: Icon(
                Icons.phone,
                color: iconColor,
              ),
            ),
            SettingsTile(
                title: currentUser.email != null
                    ? (currentUser.email.isNotEmpty
                        ? currentUser.email
                        : 'No email address provided')
                    : 'No email address provided',
                leading: Icon(
                  Icons.email,
                  color: iconColor,
                )),
            //SettingsTile(title: 'Sign out', leading: Icon(Icons.exit_to_app)),
          ],
        ),
        SettingsSection(
          title: 'Security',
          tiles: [
            SettingsTile.switchTile(
                title: 'Use fingerprint',
                subtitle: 'Allow application to access stored fingerprint IDs.',
                subtitleTextStyle: TextStyle(
                  color: Colors.white,
                ),
                leading: Icon(
                  Icons.fingerprint,
                  color: iconColor,
                ),
                onToggle: (bool value) async {
                  await _authenticateWithBiometrics();
                  final prefs = await SharedPreferences.getInstance();
                  setState(() {
                    fingerprintIsAbilitated = !fingerprintIsAbilitated;
                  });
                  prefs.setBool('fingerprint', fingerprintIsAbilitated);
                  //await _buildShowFingerprintDialog(context);
                },
                switchValue: fingerprintIsAbilitated),
            /*currentUser.isAnonymous ? null : */ SettingsTile(
              title: 'Change password',
              leading: Icon(
                Icons.lock,
                color: iconColor,
              ),
              onPressed: (context) async {
                await _buildShowChangePasswordDialog(context);
                if (userNewPwdSecondInsert.isEmpty) {
                  return null;
                }
                try {
                  await currentUser.updatePassword(userNewPwdSecondInsert);
                } catch (error) {
                  return _buildShowErrorDialog(context, error.toString());
                }
                AuthCredential authCredential = EmailAuthProvider.credential(
                    email: currentUser.email, password: userNewPwdSecondInsert);
                try {
                  await currentUser
                      .reauthenticateWithCredential(authCredential);
                  print("User reauthenticated successfully");
                } catch (error) {
                  return _buildShowErrorDialog(context, error.toString());
                }
                return _buildShowSuccessDialog(
                    context, 'Password correctly changed');
              },
            ),
          ],
        ),
      ],
    );
  }

  Future _buildShowChangePasswordDialog(BuildContext context) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
            backgroundColor: Color(0xFF141221),
            scrollable: true,
            title: Text('Change Password'),
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              child: SingleChildScrollView(
                  child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      onSaved: (value) => userCurrentPwd = value,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        hintText: 'Enter your current password',
                        hintStyle: kHintTextStyle,
                      ),
                    ),
                    TextFormField(
                      onSaved: (value) => userNewPwdFirstInsert = value,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                      validator: (value) {
                        RegExp regex = new RegExp(_passwordPattern);
                        if (!regex.hasMatch(value)) {
                          return 'Invalid password; it should contain at least 8 characters, 1 upper case and 1 lowercase letter, a digit and a special symbol';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        hintText: 'Enter your new password',
                        hintStyle: kHintTextStyle,
                      ),
                    ),
                    TextFormField(
                      onSaved: (value) => userNewPwdSecondInsert = value,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                      ),
                      validator: (value) {
                        RegExp regex = new RegExp(_passwordPattern);
                        if (!regex.hasMatch(value)) {
                          return 'Invalid password; it should contain at least 8 charachters, 1 upper case and 1 lowercase letter, a digit and a special symbol';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 14.0),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        hintText: 'Confirm your new password',
                        hintStyle: kHintTextStyle,
                      ),
                    ),
                  ],
                ),
              )),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    'Change password',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    final form = _formKey.currentState;
                    form.save();
                    if (userNewPwdFirstInsert == userNewPwdSecondInsert) {
                      Navigator.of(context).pop();
                    } else {
                      _buildShowErrorDialog(context, 'Password mismatch');
                    }
                  }),
            ]);
      },
      context: context,
    );
  }

  Future _buildShowFingerprintDialog(BuildContext context) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
            backgroundColor: Color(0xFF141221),
            scrollable: true,
            title: Text('Fingerprint'),
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_supportState == _SupportState.unknown)
                      CircularProgressIndicator()
                    else if (_supportState == _SupportState.supported)
                      Text("This device is supported")
                    else
                      Text("This device is not supported"),
                    Divider(height: 20),
                    Text('Available biometrics: $_availableBiometrics\n'),
                    Divider(height: 20),
                    Text('Current State: $_authorized\n'),
                    (_isAuthenticating)
                        ? ElevatedButton(
                            onPressed: _cancelAuthentication,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Cancel Authentication"),
                                Icon(Icons.cancel),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              ElevatedButton(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Authenticate'),
                                    Icon(Icons.perm_device_information),
                                  ],
                                ),
                                onPressed: _authenticate,
                              ),
                              ElevatedButton(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(_isAuthenticating
                                        ? 'Cancel'
                                        : 'Authenticate: biometrics only'),
                                    Icon(Icons.fingerprint),
                                  ],
                                ),
                                onPressed: _authenticateWithBiometrics,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: Text(
                    'Change password',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (userNewPwdFirstInsert == userNewPwdSecondInsert) {
                      Navigator.of(context).pop();
                    } else {
                      _buildShowErrorDialog(context, 'Password mismatch');
                    }
                  })
            ]);
      },
      context: context,
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
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }

  Future _buildShowSuccessDialog(BuildContext context, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text('Success'),
          content: Text(_message),
          actions: <Widget>[
            TextButton(
                child: Text('OK'),
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

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
