import 'package:flutter_driver/driver_extension.dart';
import 'package:eventsapp/main.dart' as app;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:google_maps_webservice/places.dart';

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  const MethodChannel channelImagePicker =
  MethodChannel('plugins.flutter.io/image_picker');

  channelImagePicker.setMockMethodCallHandler((MethodCall methodCall) async {
    ByteData data = await rootBundle.load('assets/images/imagePickerTest.jpeg');
    Uint8List bytes = data.buffer.asUint8List();
    Directory tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/tmp.tmp', ).writeAsBytes(bytes);
    print(file.path);
    return file;//file.path;
  });

  const MethodChannel channelGooglePlaces =
  MethodChannel('plugins.flutter.io/flutter_google_places');

  channelGooglePlaces.setMockMethodCallHandler((MethodCall methodCall) async {
    //List<Term> termsList = ["Milano", "Metropolitan City of Milan", "Italy"];
    return Prediction(description: "Milano, Metropolitan City of Milan, Italy", id: null, distanceMeters: null, placeId: "ChIJ53USP0nBhkcRjQ50xhPN_zw", reference: "ChIJ53USP0nBhkcRjQ50xhPN_zw");
  });

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  app.main();
}