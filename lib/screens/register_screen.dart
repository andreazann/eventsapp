import 'package:eventsapp/auth.dart';
import 'package:flutter/material.dart';
import 'package:eventsapp/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  //final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.white,
    elevation: 5.0,
    padding: EdgeInsets.all(15.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
          key: const Key('emailText'),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            onChanged: (val) {
              setState(() => _email = val);
            },
            keyboardType: TextInputType.emailAddress,
            key: const Key('emailTextField'),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
          key: const Key('passwordText'),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            obscureText: true,
            onChanged: (val) {
              setState(() => _password = val);
            },
            key: const Key('passwordTextField'),
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
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFirstNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'First name',
          style: kLabelStyle,
          key: const Key('firstnameText'),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            onChanged: (val) {
              setState(() => _firstName = val);
            },
            keyboardType: TextInputType.name,
            key: const Key('firstnameTextField'),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.verified_user,
                color: Colors.white,
              ),
              hintText: 'Enter your first name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Last name',
          style: kLabelStyle,
          key: const Key('lastnameText'),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            onChanged: (val) {
              setState(() => _lastName = val);
            },
            keyboardType: TextInputType.name,
            key: const Key('lastnameTextField'),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.verified_user,
                color: Colors.white,
              ),
              hintText: 'Enter your last name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF73AEF5),
        elevation: 0.0,
        //title: Text('Sign up'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF73AEF5),
              Color(0xFF61A4F1),
              Color(0xFF478DE0),
              Color(0xFF398AE5),
            ],
            stops: [0.1, 0.4, 0.7, 0.9],
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Sign Up',
                  key: const Key('Sign Up'),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                _buildFirstNameTF(),
                SizedBox(height: 20.0),
                _buildLastNameTF(),
                SizedBox(height: 20.0),
                _buildEmailTF(),
                SizedBox(height: 20.0),
                _buildPasswordTF(),
                SizedBox(height: 20.0),
                TextButton(
                    style: raisedButtonStyle,
                    child: Text(
                      'REGISTER',
                      key: const Key('REGISTER'),
                      style: TextStyle(
                        color: Color(0xFF527DAA),
                        letterSpacing: 1.5,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                    onPressed: () async {
                      // save the fields..
                      final form = _formKey.currentState;
                      form.save();

                      // Validate will return true if is valid, or false if invalid.
                      if (form.validate()) {
                        var user = await Provider.of<AuthService>(context,
                                listen: false)
                            .createUser(
                                firstName: _firstName,
                                lastName: _lastName,
                                email: _email,
                                password: _password);
                        if (user == null) {
                          return _buildShowErrorDialog(context,
                              "Error Registering With Those Credentials\n"
                                  "An account with that email already exists");
                        } else {
                          if (!user.emailVerified) {
                            String urlDyn = "https://evntapp.page.link/verifyEmail";
                            var actionCodeSettings = ActionCodeSettings(
                                url: urlDyn,
                                androidInstallApp: true,
                                handleCodeInApp: true,
                                androidPackageName: "com.example.eventsapp",
                                iOSBundleId: "com.example.eventsapp",
                                androidMinimumVersion: "21"
                            );
                            await user.sendEmailVerification(actionCodeSettings);
                            List<String> list = [];
                            list.add(_email);
                            list.add(_password);
                            _showSnackBar(context, 'An email has been sent to the email address specified; please verify your email address');
                            Navigator.of(context).pop(list);
                            /*Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen(user)),
                          );*/
                          }
                        }
                      } else {
                        return _buildShowErrorDialog(
                            context, "Fill all the fields");
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const Key('registerSnackbar'),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        duration: Duration(seconds: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
