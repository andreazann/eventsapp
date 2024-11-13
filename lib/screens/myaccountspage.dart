import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../auth.dart';
import '../utilities/navigation_bloc.dart';
import 'package:eventsapp/screens/coupon.dart';
import 'package:eventsapp/utilities/avatar.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MyAccountsPage extends StatefulWidget with NavigationStates {
  @override
  _MyAccountsPageState createState() => _MyAccountsPageState();
}

class _MyAccountsPageState extends State<MyAccountsPage> {
  User currentUser = FirebaseAuth.instance.currentUser;

  Future<Iterable<Map<String, List<String>>>> getAllPrefs(context) async {
    try {
      CollectionReference availableBrands =
          FirebaseFirestore.instance.collection('Brands');
      Set<String> brands = {};
      await availableBrands.get().then((value) => {
            value.docs.forEach((element) {
              brands.add(element.id);
            })
          });

      DocumentReference userCoupons =
          FirebaseFirestore.instance.collection('coupons').doc(currentUser.uid);
      Map<String, List<String>> coupons = new Map();
      for (String key in brands) {
        try {
          await userCoupons.collection(key).get().then((value) => {
                value.docs.forEach((element) {
                  if (!coupons.keys.contains(key)) {
                    coupons.putIfAbsent(key, () => [element.data()['coupon']]);
                  } else {
                    coupons[key].add(element.data()['coupon']);
                  }
                })
              });
        } catch (error) {
          print(error);
        }
      }
      // Take only the brands for which the user has at least a coupon
      Set<String> presentBrands = {};
      coupons.keys.forEach((element) {
        presentBrands.add(element);
      });
      return presentBrands
          .map<Map<String, List<String>>>((key) => <String, List<String>>{
                key: coupons[key],
              });
    } catch (error) {
      print(error);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs
          .getKeys()
          .map<Map<String, List<String>>>((key) => <String, List<String>>{
                key: prefs.getStringList(key),
              });
      //.toList(growable: false);
    }
  }

  String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future _buildPickerImageDialog(BuildContext context) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF141221),
          scrollable: true,
          title: Text('Select file picker'),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ElevatedButton(
                    child: Text('Camera'),
                    onPressed: () async {
                      Navigator.pop(context);
                      return await ImagePicker()
                          .getImage(source: ImageSource.camera);
                    },
                  ),
                  ElevatedButton(
                    child: Text('Gallery'),
                    onPressed: () async {
                      Navigator.pop(context);
                      return await ImagePicker()
                          .getImage(source: ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.lightBlueAccent, Colors.blueAccent])),
              child: Container(
                width: double.infinity,
                height: 200.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Stack(
                        key: const Key('avatarNameAndImageStack'),
                        children: [
                          Avatar(
                            avatarUrl: currentUser?.photoURL,
                            onTap: () async {
                              PickedFile image = await ImagePicker().getImage(
                                  source: ImageSource
                                      .gallery); //_buildPickerImageDialog(context); //Camera service is not straightforward to implement

                              FirebaseStorage _storage =
                                  FirebaseStorage.instanceFor(
                                      bucket:
                                          "gs://eventsapp-98b81.appspot.com");

                              var storageRef = _storage
                                  .ref()
                                  .child("user/profile/${currentUser.uid}");
                              String downloadUrl;
                              await storageRef
                                  .putFile(File(image.path))
                                  .then((result) async {
                                downloadUrl = await result.ref.getDownloadURL();
                              });

                              await currentUser.updatePhotoURL(downloadUrl);

                              setState(() {}); // Update profile photo

                              /*Future<String> getUserProfileImage(String uid) async
                            return await _storage.ref().child("user/profile/$uid").getDownloadURL();*/
                            },
                          ),
                          /*Positioned(
                            child: Center(
                                child: Icon(
                              Icons.camera_alt,
                              color: Colors.white.withOpacity(0.1),
                            )),
                          ),*/
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        currentUser.displayName == null
                            ? 'Anonymous user'
                            : (currentUser.displayName.isEmpty
                                ? 'No name provided'
                                : currentUser.displayName),
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              )),
          Container(
            child: Expanded(
              child: Center(
                child: Scaffold(
                  body: FutureBuilder<Iterable<Map<String, List<String>>>>(
                      future: getAllPrefs(context),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Container();
                        if(snapshot.data.isEmpty)
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'No coupon available\nEnjoy some branded content in the Branded section of the home page to collect some coupons',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        List<Widget> coupons = [];
                        for (Map<String, List<String>> element
                            in snapshot.data) {
                          coupons.add(Text(element.keys.first));
                          coupons.add(SizedBox(
                            height: 10.0,
                          ));
                          for (List<String> coups in element.values) {
                            for (String coup in coups) {
                              coupons.add(Material(
                                child: Container(
                                  child: Text(
                                    "Coupon of $coup% discount: ${getRandomString(5)}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  /*Row(
                                    children: [
                                      Text(
                                        "Coupon of $coup% discount: ${getRandomString(5)}",
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            getRandomString(5),
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16.0,
                                            ),
                                          )),
                                    ],
                                  ),*/
                                  padding: EdgeInsets.all(15.0),
                                ),
                                color: Colors.orange,
                                elevation: 1.0,
                                shape: CouponShapeBorder(),
                              ));
                              coupons.add(SizedBox(
                                height: 10.0,
                              ));
                            }
                          }
                        }
                        return ListView(
                          children: coupons,
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 10,
                            right: 10,
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          /*Container(
            width: 300.00,
            child: RaisedButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                elevation: 0.0,
                padding: EdgeInsets.only(bottom: 15),
                color: Colors.white,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [Colors.lightBlueAccent, Colors.blueAccent]),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Contact me",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                )),
          ),*/
        ],
      ),
    );
  }
}
