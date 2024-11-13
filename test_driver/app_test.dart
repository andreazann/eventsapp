// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

// First, define the Finders and use them to locate widgets from the
// test suite. Note: the Strings provided to the `byValueKey` method must
// be the same as the Strings we used for the Keys in step 1.
final signinTextFinder = find.byValueKey('Sign');
final emailTextFinder = find.byValueKey('Email');
final emailRegisterScreenTextFinder = find.byValueKey('emailText');
final passwordTextFinder = find.byValueKey('Password');
final passwordRegisterScreenTextFinder = find.byValueKey('passwordText');
final noaccountTextFinder = find.byValueKey('NoAccount');
final remembermeTextFinder = find.byValueKey('Remember');
final forgotpasswordTextFinder = find.byValueKey('Forgot Password');
final signupTextFinder = find.byValueKey('SIGN');
final loginTextFinder = find.byValueKey('LOGIN');
final registerTextFinder = find.byValueKey('REGISTER');
final resetPasswordTextFinder = find.byValueKey('RESET PASSWORD');
final signUpTextFinder = find.byValueKey('Sign Up');
final buttonSignupFinder = find.byValueKey('SIGN');
final buttonForgotPasswordFinder = find.byValueKey('Forgot Password');
final buttonLoginFinder = find.byValueKey('LOGIN');
final usernameTextFieldFinder = find.byValueKey('usernameTextField');
final passwordTextFieldFinder = find.byValueKey('passwordTextField');
final carouselWidgetFinder = find.byValueKey('carouselWidgetFraction');
final tabbedWidgetFinder = find.byValueKey('tabbedWidgetFraction');
final allEventTabbedWidgetFinder = find.byValueKey('allEventTabbedWidget');
final brandEventTabbedWidgetFinder = find.byValueKey('brandEventTabbedWidget');
final nearEventTabbedWidgetFinder = find.byValueKey('nearEventTabbedWidget');
final buttonSidebarClipperFinder = find.byValueKey('Clipper');
final homeSidebarElementFinder = find.byValueKey('Home sidebar');
final myAccountSidebarElementFinder = find.byValueKey('My account sidebar');
final createEventSidebarElementFinder = find.byValueKey('Create event sidebar');
final settingsSidebarElementFinder = find.byValueKey('Settings sidebar');
final logoutSidebarElementFinder = find.byValueKey('Logout sidebar');
final avatarNameAndImageStackFinder = find.byValueKey('avatarNameAndImageStack');
final createEventTitleFinder = find.byValueKey('createEventTitleText');
final settingsTitleFinder = find.byValueKey('settingsTitle');

final firstnameTextFinder = find.byValueKey('firstnameText');
final lastnameTextFinder = find.byValueKey('lastnameText');
final firstnameTextFieldFinder = find.byValueKey('firstnameTextField');
final lastnameTextFieldFinder = find.byValueKey('lastnameTextField');
final emailTextFieldFinder = find.byValueKey('emailTextField');
final registerButtonFinder = find.byValueKey('REGISTER');
final snackbarWidgetFinder = find.byValueKey('registerSnackbar');
final snackbarForgotPasswordWidgetFinder = find.byValueKey('forgotPasswordSnackbar');

final forgotPasswordTextFieldFinder = find.byValueKey('forgotPasswordTextField');
final resetPasswordTitleTextFinder = find.byValueKey('resetPasswordTitle');

final createEventTitleTextFinder = find.byValueKey('titleCreateEventText');
final createEventTypeTextFinder = find.byValueKey('typeCreateEventText');
final createEventDescriptionTextFinder = find.byValueKey('descriptionCreateEventText');
final createEventVideoUrlTextFinder = find.byValueKey('videoUrlCreateEventText');
final createEventMapSearchTextFinder = find.byValueKey('mapSearchCreateEventText');
final createEventUploadImageTextFinder = find.byValueKey('uploadImageCreateEventText');
final createEventCreateEventTextFinder = find.byValueKey('createEventCreateEventText');
final createEventTitleTextFieldFinder = find.byValueKey('titleCreateEventTextField');
final createEventTypeTextFieldFinder = find.byValueKey('typeCreateEventTextField');
final createEventDescriptionTextFieldFinder = find.byValueKey('descriptionCreateEventTextField');
final createEventVideoUrlTextFieldFinder = find.byValueKey('videoUrlCreateEventTextField');
final createEventMapSearchButtonFinder = find.byValueKey('mapSearchCreateEventButton');
final createEventUploadImageButtonFinder = find.byValueKey('uploadImageCreateEventButton');
final createEventCreateEventButtonFinder = find.byValueKey('createEventCreateEventButton');
final createEventLoadingCircleWidgetFinder = find.byValueKey('loadingCircleWidget');

final eventCardWidgetFinder = find.byValueKey('eventCardWidget1');
final eventCardBrandWidgetFinder = find.byValueKey('eventCardWidget0');
final eventCarouselCardWidgetFinder = find.byValueKey('eventCarouselCard0');
final googleMapsEventDetailWidgetFinder = find.byValueKey('googleMapsEventDetailWidget');
final youtubePlayerEventDetailWidgetFinder = find.byValueKey('youtubePlayerEventDetailWidget');
final eventTitleEventDetailTextFinder = find.byValueKey('eventTitleEventDetailText');
final eventDescriptionEventDetailTextFinder = find.byValueKey('eventDescriptionEventDetailText');
final arrowPageBackButton = find.byValueKey('pageBack');

void main() {
  group('Navigation: ', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    test('Login screen: sign in is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(signinTextFinder), "Sign In");
    });

    test('Login screen: email is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(emailTextFinder), "Email");
    });

    test('Login screen: password is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(passwordTextFinder), "Password");
    });

    test('Login screen: noaccount is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(noaccountTextFinder), "Don\'t have an Account?");
    });

    test('Login screen: forgot password is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(forgotpasswordTextFinder), "Forgot Password?");
    });

    /*test('rememberme is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(remembermeTextFinder), "Remember me");
    });*/

    test('Login screen: login is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(loginTextFinder), "LOGIN");
    });

    test('Login screen: signup button is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(signupTextFinder), "SIGN UP");
    });

    test('Login screen: register screen is reachable', () async {
      await driver.runUnsynchronized(() async {
        // First, scroll till button is visible
        await driver.scrollIntoView(buttonSignupFinder);
        // Second, tap the button.
        await driver.tap(buttonSignupFinder);

        // Then, verify the registration screen is displayed.
        expect(await driver.getText(registerTextFinder), "REGISTER");
        expect(await driver.getText(signUpTextFinder), "Sign Up");

        // Finally, get back to primary screen
        await driver.tap(find.pageBack());
      });
    });

    test('Login screen: forgot password screen is reachable', () async {
      await driver.runUnsynchronized(() async {
        // First, tap the button.
        await driver.tap(buttonForgotPasswordFinder);

        // Then, verify the registration screen is displayed.
        expect(await driver.getText(resetPasswordTextFinder), "RESET PASSWORD");

        // Finally, get back to primary screen
        await driver.tap(find.pageBack());
      });
    });

    test('Login screen: Log in action', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(usernameTextFieldFinder);
        await driver.enterText('test@test.com');
        await driver.waitFor(find.text('test@test.com'));

        await driver.tap(passwordTextFieldFinder);
        await driver.enterText('Test123');
        await driver.waitFor(find.text('Test123'));

        await driver.tap(buttonLoginFinder);
        bool widgetsPresent = false;
        try {
          await driver.waitFor(carouselWidgetFinder);
          await driver.waitFor(tabbedWidgetFinder);
          widgetsPresent = true;
        } catch (error) {
          widgetsPresent = false;
        }
        expect(widgetsPresent, true);
      });
    });

    test('Sidebar menu: sidebar elements are visible', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(buttonSidebarClipperFinder);

        bool widgetsPresent = false;
        try {
          await driver.waitFor(homeSidebarElementFinder);
          await driver.waitFor(myAccountSidebarElementFinder);
          await driver.waitFor(createEventSidebarElementFinder);
          await driver.waitFor(settingsSidebarElementFinder);
          await driver.waitFor(logoutSidebarElementFinder);
          widgetsPresent = true;
        } catch (error) {
          widgetsPresent = false;
        }
        expect(widgetsPresent, true);
      });
    });

    test('Sidebar menu: my account item brings up my account screen', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(buttonSidebarClipperFinder);
        await driver.tap(myAccountSidebarElementFinder);

        bool widgetsPresent = false;
        try {
          await driver.waitFor(avatarNameAndImageStackFinder);
          widgetsPresent = true;
        } catch (error) {
          widgetsPresent = false;
        }
        expect(widgetsPresent, true);
      });
    });

    test('Sidebar menu: create event item brings up event creation screen', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(buttonSidebarClipperFinder);
        await driver.tap(createEventSidebarElementFinder);

        expect(await driver.getText(createEventTitleFinder), 'Create event');
      });
    });

    test('Sidebar menu: settings item brings up setting screen', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(buttonSidebarClipperFinder);
        await driver.tap(settingsSidebarElementFinder);

        expect(await driver.getText(settingsTitleFinder), 'Settings');
      });
    });

    /*test('Sidebar menu: home item brings up home page screen', () async {
      await driver.runUnsynchronized(() async {
        //await Future.delayed(const Duration(seconds: 5), (){});
        await driver.tap(homeSidebarElementFinder);


        bool widgetsPresent = false;
        try {
          await driver.waitFor(carouselWidgetFinder);
          await driver.waitFor(tabbedWidgetFinder);
          widgetsPresent = true;
        } catch (error) {
          print('Home button sidebar error');
          widgetsPresent = false;
        }
        expect(widgetsPresent, true);
      });
    });*/

    test('Sidebar menu: logout item brings up log in screen and logs out the user', () async {
      await driver.runUnsynchronized(() async {
        print('sidebar logout');
        //await Future.delayed(const Duration(seconds: 5), (){});
        await driver.tap(buttonSidebarClipperFinder);
        await driver.tap(logoutSidebarElementFinder);

        await Future.delayed(const Duration(seconds: 2), (){});
        await driver.tap(buttonSidebarClipperFinder);
        await driver.tap(logoutSidebarElementFinder);
        /*print('sidebar logout 2');
        //await Future.delayed(const Duration(seconds: 5), (){});
        await driver.tap(buttonSidebarClipperFinder);
        await driver.tap(logoutSidebarElementFinder);*/
        /*try {
          expect(await driver.getText(signinTextFinder), "Sign In");
          expect(await driver.getText(emailTextFinder), "Email");
          expect(await driver.getText(passwordTextFinder), "Password");
        } catch (error) {
          print(error.toString());
          print('sidebar logout 2');
          await Future.delayed(const Duration(seconds: 5), (){});
          await driver.tap(buttonSidebarClipperFinder);
          await driver.tap(logoutSidebarElementFinder);

          expect(await driver.getText(signinTextFinder), "Sign In");
          expect(await driver.getText(emailTextFinder), "Email");
          expect(await driver.getText(passwordTextFinder), "Password");
        }*/
        expect(await driver.getText(signinTextFinder), "Sign In");
        expect(await driver.getText(emailTextFinder), "Email");
        expect(await driver.getText(passwordTextFinder), "Password");
      });
    });
  });

  group('Forgot password widget: ', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    test('forgot password button is present and when tapped brings up forgot password screen', () async {
      await driver.runUnsynchronized(() async {
        // First, tap the button.
        await driver.tap(buttonForgotPasswordFinder);
      });
    });

    test('reset password title is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(resetPasswordTitleTextFinder), "Reset Password");
    });

    test('reset password text field is present', () async {
      bool widgetsPresent = false;
      try {
        await driver.waitFor(forgotPasswordTextFieldFinder);
        widgetsPresent = true;
      } catch (error) {
        widgetsPresent = false;
      }
      expect(widgetsPresent, true);
    });

    test('reset password button is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(resetPasswordTextFinder), "RESET PASSWORD");
    });

    test('reset password action', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(forgotPasswordTextFieldFinder);
        await driver.enterText('test3@test.com');
        await driver.waitFor(find.text('test3@test.com'));

        await driver.tap(resetPasswordTextFinder);
        bool widgetsPresent = false;
        try {
          await driver.waitFor(snackbarForgotPasswordWidgetFinder);
          expect(await driver.getText(signinTextFinder), "Sign In");
          widgetsPresent = true;
        } catch (error) {
          widgetsPresent = false;
        }
        expect(widgetsPresent, true);
      });
    });
  });

  group('Register widget: ', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    test('register button is present and when tapped brings up register screen', () async {
      await driver.runUnsynchronized(() async {
        // First, scroll till button is visible
        await driver.scrollIntoView(buttonSignupFinder);
        // Second, tap the button.
        await driver.tap(buttonSignupFinder);
      });
    });

    test('first name is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(firstnameTextFinder), "First name");
    });

    test('last name is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(lastnameTextFinder), "Last name");
    });

    test('email is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(emailRegisterScreenTextFinder), "Email");
    });

    test('password is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(passwordRegisterScreenTextFinder), "Password");
    });

    test('Register action', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(firstnameTextFieldFinder);
        await driver.enterText('TestName');
        await driver.waitFor(find.text('TestName'));

        await driver.tap(lastnameTextFieldFinder);
        await driver.enterText('TestLastName');
        await driver.waitFor(find.text('TestLastName'));

        await driver.tap(emailTextFieldFinder);
        await driver.enterText('test3@test.com');
        await driver.waitFor(find.text('test3@test.com'));

        await driver.tap(passwordTextFieldFinder);
        await driver.enterText('Test123');
        await driver.waitFor(find.text('Test123'));

        await driver.tap(registerButtonFinder);
        bool widgetsPresent = false;
        try {
          await driver.waitFor(snackbarWidgetFinder);
          await driver.waitFor(carouselWidgetFinder);
          await driver.waitFor(tabbedWidgetFinder);
          widgetsPresent = true;
        } catch (error) {
          widgetsPresent = false;
        }
        expect(widgetsPresent, true);
      });
    });

    //login(driver, 'jack.albero10@gmail.com', 'Test123');
  });

  /*group('Sign in widget', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    test('sign in is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(signinTextFinder), "Sign In");
    });

    test('email is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(emailTextFinder), "Email");
    });

    test('password is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(passwordTextFinder), "Password");
    });

    test('noaccount is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(noaccountTextFinder), "Don\'t have an Account?");
    });

    test('forgotpassword is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(forgotpasswordTextFinder), "Forgot Password?");
    });

    test('login is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(loginTextFinder), "LOGIN");
    });

    test('signup is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(signupTextFinder), "SIGN UP");
    });

    test('Log in', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(usernameTextFieldFinder);
        await driver.enterText('test2@test.com');
        await driver.waitFor(find.text('test2@test.com'));

        await driver.tap(passwordTextFieldFinder);
        await driver.enterText('Test123');
        await driver.waitFor(find.text('Test123'));

        await driver.tap(buttonLoginFinder);
        bool widgetsPresent = false;
        try {
          await driver.waitFor(carouselWidgetFinder);
          await driver.waitFor(tabbedWidgetFinder);
          widgetsPresent = true;
        } catch (error) {
          widgetsPresent = false;
        }
        expect(widgetsPresent, true);
      });
    });
  });*/

  /*group('Create event', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    test('sidebar create event button', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(buttonSidebarClipperFinder);
        await Future.delayed(const Duration(seconds: 2), (){});
        await driver.tap(createEventSidebarElementFinder);

        expect(await driver.getText(createEventTitleFinder), 'Create event');
      });
    });

    test('create event title is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(createEventTitleFinder), "Create event");
    });

    test('title is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(createEventTitleTextFinder), "Title");
    });

    test('type is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(createEventTypeTextFinder), "Type");
    });

    test('description is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(createEventDescriptionTextFinder), "Description");
    });

    test('videoUrl is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(createEventVideoUrlTextFinder), "Video URL");
    });

    test('map search is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(createEventMapSearchTextFinder), "MAP SEARCH");
    });

    test('image button is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(createEventUploadImageTextFinder), "UPLOAD IMAGE");
    });

    test('create event button is present', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(createEventCreateEventTextFinder), "CREATE EVENT");
    });

    test('Create event', () async {
      await driver.runUnsynchronized(() async {
        print('Title inserting');
        await driver.tap(createEventTitleTextFieldFinder);
        await driver.enterText('FlutterDriverTest');
        await driver.waitFor(find.text('FlutterDriverTest'));

        print('Type inserting');
        await driver.tap(createEventTypeTextFieldFinder);
        await driver.enterText('Test');
        await driver.waitFor(find.text('Test'));

        print('Description inserting');
        await driver.tap(createEventDescriptionTextFieldFinder);
        await driver.enterText('This is an event created through automated testing with flutter driver');
        await driver.waitFor(find.text('This is an event created through automated testing with flutter driver'));

        print('Image upload button tapping');
        await driver.tap(createEventUploadImageButtonFinder);
        print('Map search button tapping');
        await driver.tap(createEventMapSearchButtonFinder);

        print('Create event button tapping');
        await driver.tap(createEventCreateEventButtonFinder);
        bool widgetsPresent = false;
        try {
          await driver.waitFor(createEventLoadingCircleWidgetFinder);
          await driver.waitFor(carouselWidgetFinder);
          await driver.waitFor(tabbedWidgetFinder);
          widgetsPresent = true;
        } catch (error) {
          widgetsPresent = false;
        }
        expect(widgetsPresent, true);
      });
    });
  });*/

  group('Home screen and event details widgets: ', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      driver.close();
    });

    test('carousel widget is present', () async {
      bool widgetsPresent = false;
      try {
        await driver.waitFor(carouselWidgetFinder);
        widgetsPresent = true;
      } catch (error) {
        widgetsPresent = false;
      }
      expect(widgetsPresent, true);
    });

    test('tabbed widget is present', () async {
      bool widgetsPresent = false;
      try {
        await driver.waitFor(tabbedWidgetFinder);
        await driver.waitFor(allEventTabbedWidgetFinder);
        await driver.waitFor(brandEventTabbedWidgetFinder);
        await driver.waitFor(nearEventTabbedWidgetFinder);
        widgetsPresent = true;
      } catch (error) {
        widgetsPresent = false;
      }
      expect(widgetsPresent, true);
    });

    test('event detail screen for brand events is visible and shows a video', () async {
      await driver.runUnsynchronized(() async {
        /*await driver.tap(buttonSidebarClipperFinder);
        await Future.delayed(const Duration(seconds: 2), (){});
        await driver.tap(homeSidebarElementFinder);*/
        await Future.delayed(const Duration(seconds: 5), (){});
        await driver.waitFor(eventCarouselCardWidgetFinder);
        //await driver.tap(brandEventTabbedWidgetFinder);
        await Future.delayed(const Duration(seconds: 5), (){});
        //await driver.waitFor(eventCardBrandWidgetFinder);
        await driver.tap(eventCarouselCardWidgetFinder);
        bool widgetsPresent = false;
        try {
          await driver.waitFor(eventTitleEventDetailTextFinder);
          await driver.waitFor(eventDescriptionEventDetailTextFinder);
          await Future.delayed(const Duration(seconds: 10), (){});
          await driver.waitFor(youtubePlayerEventDetailWidgetFinder);
          widgetsPresent = true;
        } catch (error) {
          widgetsPresent = false;
        }
        expect(widgetsPresent, true);
      });
    },timeout: Timeout(Duration(seconds: 60)));

    /*test('event detail screen for no-brand events is visible and shows the map', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(arrowPageBackButton);
        await Future.delayed(const Duration(seconds: 5), (){});
        await driver.waitFor(eventCardBrandWidgetFinder);
        await driver.tap(allEventTabbedWidgetFinder);
        await Future.delayed(const Duration(seconds: 5), (){});
        await driver.waitFor(eventCardWidgetFinder);
        await driver.tap(eventCardWidgetFinder);
        bool widgetsPresent = false;
        try {
          await driver.waitFor(eventTitleEventDetailTextFinder);
          await driver.waitFor(eventDescriptionEventDetailTextFinder);
          await driver.waitFor(googleMapsEventDetailWidgetFinder);
          widgetsPresent = true;
        } catch (error) {
          widgetsPresent = false;
        }
        expect(widgetsPresent, true);
      });
    });*/

    test('logout', () async {
      await driver.runUnsynchronized(() async {
        //await Future.delayed(const Duration(seconds: 5), (){});
        await driver.tap(buttonSidebarClipperFinder);
        await driver.tap(logoutSidebarElementFinder);

        await Future.delayed(const Duration(seconds: 5), (){});
        await driver.tap(buttonSidebarClipperFinder);
        await driver.tap(logoutSidebarElementFinder);

        expect(await driver.getText(signinTextFinder), "Sign In");
        expect(await driver.getText(emailTextFinder), "Email");
        expect(await driver.getText(passwordTextFinder), "Password");
      });
    });
  });
}

/* EXAMPLES OF FINDING ELEMENTS BY TYPE, ALL OF THEM OR ONLY SOME OF THEM...
test('IconButton find and tap test', () async {
  var findIconButton = find.descendant(of: find.byType("Align"), matching: find.byType("IconButton"), firstMatchOnly: true);
  await driver.waitFor(findIconButton);
  await driver.tap(findIconButton);

  await Future.delayed(Duration(seconds: 3));
});

find.descendant(of: find.ancestor(
                  of: find.byValue("somevalue"),
                  matching: find.byType("CustomWidgetClass")), matching: find.byType("IconButton"), firstMatchOnly: true)
*/