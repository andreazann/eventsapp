import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eventsapp/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:eventsapp/auth.dart';
import 'package:eventsapp/screens/register_screen.dart';
import 'package:eventsapp/screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _email;

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
          key: const Key('Email'),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            onSaved: (value) => _email = value,
            keyboardType: TextInputType.emailAddress,
            key: const Key('usernameTextField'),
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
          key: const Key('Password'),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            onSaved: (value) => _password = value,
            obscureText: true,
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

  Widget _buildForgotPasswordBtn() {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      padding: EdgeInsets.only(right: 0.0),
    );

    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
          );
        },
        style: flatButtonStyle,
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
          key: const Key('Forgot Password'),
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.blueAccent,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
            key: const Key('Remember'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      primary: Colors.white,
      elevation: 5.0,
      padding: EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: raisedButtonStyle,
        onPressed: () async {
          // save the fields..
          final form = _formKey.currentState;
          form.save();

          // Validate will return true if is valid, or false if invalid.
          if (form.validate()) {
            var result = await Provider.of<AuthService>(context, listen: false)
                .loginUser(email: _email, password: _password);
            if (result == null) {
              return _buildShowErrorDialog(
                  context, "Error Logging In With Those Credentials");
            } // else {
            //Navigator.pushReplacementNamed(context, "/");
            //}
          } else {
            return _buildShowErrorDialog(
                context, "Fill all the fields");
          }
        },
        child: Text(
          'LOGIN',
          key: const Key('LOGIN'),
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () async {
              var result = await Provider.of<AuthService>(context, listen: false)
                  .loginAsGuest();
              if (result == null) {
                return _buildShowErrorDialog(
                    context, "Error logging in as guest");
              }
            },
            AssetImage(
              'assets/logos/2a.png',
            ),
          ),
          _buildSocialBtn(
            () async {
              var result = await Provider.of<AuthService>(context, listen: false)
                  .loginUserWithGoogle();
              if (result == null) {
                return _buildShowErrorDialog(
                    context, "Error logging in with Google");
              }
            },
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      primary: Colors.white,
      elevation: 5.0,
      padding: EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Text(
            'Don\'t have an Account?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
            key: const Key('NoAccount'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              var singUpResult = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
              /*if(singUpResult != null){
                if (mounted) {
                  setState(() {
                    _email = (singUpResult as List<String>)[0];
                    _password = (singUpResult as List<String>)[1];
                  });
                }
                var result =
                    await Provider.of<AuthService>(context, listen: false)
                        .loginUser(
                            email: (singUpResult as List<String>)[0],
                            password: (singUpResult as List<String>)[1]);
                if (result == null) {
                  return _buildShowErrorDialog(
                      context, "Error Logging In With Those Credentials");
                } else {
                  print("User logged in successfully");
                  print(result.displayName);
                }
              }*/
            },
            child: Text(
              'SIGN UP',
              key: const Key('SIGN'),
              style: TextStyle(
                color: Color(0xFF527DAA),
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                letterSpacing: 1.5,
              ),
            ),
            style: raisedButtonStyle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
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
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 120.0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Sign In',
                            key: const Key('Sign'),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          _buildEmailTF(),
                          SizedBox(
                            height: 30.0,
                          ),
                          _buildPasswordTF(),
                          _buildForgotPasswordBtn(),
                          //_buildRememberMeCheckbox(),
                          _buildLoginBtn(),
                          _buildSignInWithText(),
                          _buildSocialBtnRow(),
                          _buildSignupBtn(),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
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
}
