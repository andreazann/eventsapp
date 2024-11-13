import 'dart:async';
import 'dart:io';

import 'package:eventsapp/utilities/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import '../utilities/navigation_bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:permission_handler/permission_handler.dart';

const kGoogleApiKeyAndroid = "AIzaSyAIvG0B_obJqPGfZBIzQ3Z6nq6Qm4CG-hc";
const kGoogleApiKeyIos = "AIzaSyCrwTXqgGalZFBwSpxs5EzDbqq1ztHOSVU";
/*Platform.isAndroid
  ? "AIzaSyAIvG0B_obJqPGfZBIzQ3Z6nq6Qm4CG-hc"
      : "AIzaSyCrwTXqgGalZFBwSpxs5EzDbqq1ztHOSVU";*/

GoogleMapsPlaces _places = GoogleMapsPlaces(
    apiKey: Platform.isAndroid ? kGoogleApiKeyAndroid : kGoogleApiKeyIos);

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class EventCreationPage extends StatefulWidget with NavigationStates {
  final User currentUser;

  EventCreationPage(this.currentUser);

  @override
  _EventCreationPageState createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PickedFile _image;

  bool isCreatingEvent = false;

  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _type = '';
  String _description = '';
  String _videoUrl = 'No video';
  double _latitude = 0.0;
  double _longitude = 0.0;

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition milanPosition = CameraPosition(
    target: LatLng(45.464664, 9.188540),
    zoom: 15.00,
  );

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    primary: Colors.white,
    elevation: 5.0,
    padding: EdgeInsets.all(15.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  );

  Widget _buildTitleTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Title',
          style: kLabelStyle,
          key: const Key('titleCreateEventText'),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyleTransparent,
          height: 60.0,
          child: TextFormField(
            onChanged: (val) {
              _title = val;
            },
            keyboardType: TextInputType.text,
            key: const Key('titleCreateEventTextField'),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.title,
                color: Colors.white,
              ),
              hintText: 'Enter the event title',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Type',
          style: kLabelStyle,
          key: const Key('typeCreateEventText'),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyleTransparent,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.text,
            onChanged: (val) {
              _type = val;
            },
            key: const Key('typeCreateEventTextField'),
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
              hintText: 'Enter the event type',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Description',
          style: kLabelStyle,
          key: const Key('descriptionCreateEventText'),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyleTransparent,
          height: 60.0,
          child: TextFormField(
            onChanged: (val) {
              _description = val;
            },
            keyboardType: TextInputType.multiline,
            key: const Key('descriptionCreateEventTextField'),
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
              hintText: 'Enter the event description',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoUrlTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Video URL',
          style: kLabelStyle,
          key: const Key('videoUrlCreateEventText'),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyleTransparent,
          height: 60.0,
          child: TextFormField(
            onChanged: (val) {
              _videoUrl = val;
            },
            initialValue: 'No video',
            keyboardType: TextInputType.text,
            key: const Key('videoUrlCreateEventTextField'),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.ondemand_video,
                color: Colors.white,
              ),
              hintText: 'Enter video url if present',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLongitudeTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Longitude',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            onChanged: (val) {
              _longitude = num.tryParse(val)?.toDouble();
            },
            keyboardType: TextInputType.number,
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
              hintText: 'Enter the event longitude',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePickerTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Image upload',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            onTap: () async {
              print(await Permission.photos.isGranted);
              if (await Permission.photos.request().isGranted) {
                _image =
                    await ImagePicker().getImage(source: ImageSource.gallery);
              }
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.image,
                color: Colors.white,
              ),
              hintText: 'Upload an image representative of the event',
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
            backgroundColor: Color(0xFF141221),
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

    // Create a CollectionReference called users that references the firestore collection
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    Future<void> addEvent() async {
      setState(() {
        isCreatingEvent = true;
      });
      /*GeoPoint geoPoint = document.getGeoPoint("position");
      double lat = geoPoint.getLatitude();
      double lng = geoPoint.getLongitude ();*/
      // save the fields..
      final form = _formKey.currentState;
      form.save();

      // Validate will return true if is valid, or false if invalid.
      if (form.validate() && _image != null) {
        GeoPoint geoPoint = new GeoPoint(_latitude, _longitude);
        FirebaseStorage _storage = FirebaseStorage.instanceFor(
            bucket: "gs://eventsapp-98b81.appspot.com");

        var storageRef = _storage.ref().child(
            "user/events/${widget.currentUser.uid}/${DateTime.now().millisecondsSinceEpoch}");
        String downloadUrl;
        await storageRef.putFile(File(_image.path)).then((result) async {
          downloadUrl = await result.ref.getDownloadURL();
        });
        // Call the event's CollectionReference to add a new event
        events.add({
          'creator': widget.currentUser.displayName, // John Doe
          'title': _title, // Stokes and Sons
          'position': geoPoint, // 42
          'type': _type,
          'description': _description,
          'imageUrl': downloadUrl,
          'videoUrl': _videoUrl,
          'date': DateTime.now(),
        }).then((event) {
          print("Event Added: $event");
          BlocProvider.of<NavigationBloc>(context)
              .add(NavigationEvents.HomePageClickedEvent);
        }).catchError((error) => print("Failed to add event: $error"));
      } else {
        setState(() {
          isCreatingEvent = false;
        });
        return _buildShowErrorDialog(context, "Fill all the fields");
      }
      setState(() {
        isCreatingEvent = false;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
        backgroundColor: Color(0xFF141251), //Color(0xFF73AEF5),
        elevation: 0.0,
        //title: Text('Sign up'),
      ),*/
      body: isCreatingEvent
          ? LoadingCircle()
          : Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF141251), //Color(0xFF73AEF5),
                    Color(0xFF141241), //Color(0xFF61A4F1),
                    Color(0xFF141231), //Color(0xFF478DE0),
                    Color(0xFF141221), //Color(0xFF398AE5),
                  ],
                  stops: [0.1, 0.4, 0.7, 0.9],
                ),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      Text(
                        'Create event',
                        key: const Key('createEventTitleText'),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      _buildTitleTF(),
                      SizedBox(height: 20.0),
                      _buildTypeTF(),
                      SizedBox(height: 20.0),
                      _buildDescriptionTF(),
                      SizedBox(height: 20.0),
                      _buildVideoUrlTF(),
                      SizedBox(height: 20.0),
                      /*_buildImagePickerTF(),
                SizedBox(height: 20.0),*/
                      ElevatedButton(
                        //key: homeScaffoldKey,
                        key: const Key('mapSearchCreateEventButton'),
                        onPressed: () async {
                          // show input autocomplete with selected mode
                          // then get the Prediction selected
                          Prediction p = await PlacesAutocomplete.show(
                            context: context,
                            apiKey: Platform.isAndroid
                                ? "AIzaSyAIvG0B_obJqPGfZBIzQ3Z6nq6Qm4CG-hc"
                                : "AIzaSyCrwTXqgGalZFBwSpxs5EzDbqq1ztHOSVU",
                            onError: onError,
                            mode: Mode.fullscreen,
                            language: "en",
                            /*decoration: InputDecoration(
                        hintText: 'Search',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),*/
                            components: [
                              Component(Component.country, "uk"),
                              Component(Component.country, "it")
                            ],
                            offset: 0,
                            radius: 1000,
                            types: [],
                            strictbounds: false,
                          );
                          var result = await displayPrediction(p, context);
                          setState(() {
                            _latitude = result['latitude'];
                            _longitude = result['longitude'];
                          });
                        },
                        child: Text(
                          'MAP SEARCH',
                          key: const Key('mapSearchCreateEventText'),
                          style: TextStyle(
                            color: Color(0xFF527DAA),
                            letterSpacing: 1.5,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          elevation: 5.0,
                          padding: EdgeInsets.all(15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      /*ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Maps()));
                    },
                    child: Text('Maps')),*/
                      SizedBox(height: 20.0),
                      _image == null
                          ? ElevatedButton(
                              key: const Key('uploadImageCreateEventButton'),
                              child: Text(
                                'UPLOAD IMAGE',
                                key: const Key('uploadImageCreateEventText'),
                                style: TextStyle(
                                  color: Color(0xFF527DAA),
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                              onPressed: () async {
                                if (await Permission.storage
                                    .request()
                                    .isGranted) {
                                  _image = await ImagePicker().getImage(
                                      source: ImageSource
                                          .gallery); //_buildPickerImageDialog(context); //Camera service is not straightforward to implement
                                  setState(() {});
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                elevation: 5.0,
                                padding: EdgeInsets.all(15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            )
                          : Image.file(File(_image.path)),
                      SizedBox(height: 20.0),
                      TextButton(
                        key: const Key('createEventCreateEventButton'),
                        style: raisedButtonStyle,
                        child: Text(
                          'CREATE EVENT',
                          key: const Key('createEventCreateEventText'),
                          style: TextStyle(
                            color: Color(0xFF527DAA),
                            letterSpacing: 1.5,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        onPressed: addEvent,
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }
}

Future<Map<String, double>> displayPrediction(Prediction p, context) async {
  if (p != null) {
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);

    var placeId = p.placeId;
    double lat = detail.result.geometry.location.lat;
    double lng = detail.result.geometry.location.lng;

    var address = await Geocoder.local.findAddressesFromQuery(p.description);

    print(lat);
    print(lng);

    _showSnackBar(context, "You have selected ${p.description}");

    return {'latitude': lat, 'longitude': lng};
    /*scaffold.showSnackBar(
      SnackBar(content: Text("${p.description} - $lat/$lng")),
    );*/
  }
}

void _showSnackBar(context, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          fontSize: 16.0,
        ),
      ),
      key: const Key('snackbarEventCreation'),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
      elevation: 1.0,
      duration: Duration(seconds: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
    ),
  );
}

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        key: const Key('loadingCircleWidget'),
        color: Colors.transparent.withOpacity(1),
        child: CircularProgressIndicator(),
        alignment: Alignment(0.0, 0.0),
      ),
    );
  }
}
