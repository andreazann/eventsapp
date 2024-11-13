import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:http/http.dart';

class ApiClient {
  final Client _client;
  ApiClient(this._client);

  final FirebaseFirestore database = FirebaseFirestore.instance;
  CollectionReference events = FirebaseFirestore.instance.collection('events');
  final geo = Geoflutterfire();

  dynamic get(String path, {Map<dynamic, dynamic> params}) async {
    Map<String, dynamic> jsonObjects = {};
    var jsonObjectsList = [];
    List<QueryDocumentSnapshot> documents = await events.get().then((value) {return value.docs;});
    for(var element in documents) {
      Map<String, dynamic> jsonTemp = {};
      GeoPoint geoPoint = await element.reference.get().then((value) => (value.get('position')?? null));
      jsonTemp['id'] = element.reference.id;
      jsonTemp['creator'] = await element.reference.get().then((value) => (value.get('creator')?? ''));
      jsonTemp['title'] = await element.reference.get().then((value) => (value.get('title')?? ''));
      jsonTemp['type'] = await element.reference.get().then((value) => (value.get('type')?? ''));
      jsonTemp['imageUrl'] = await element.reference.get().then((value) => (value.get('imageUrl')?? ''));
      jsonTemp['description'] = await element.reference.get().then((value) => (value.get('description')?? ''));
      jsonTemp['latitude'] = geoPoint?.latitude;
      jsonTemp['longitude'] = geoPoint?.longitude;
      jsonTemp['videoUrl'] = await element.reference.get().then((value) => (value.get('videoUrl')?? ''));
      //print(jsonTemp);
      jsonObjectsList.add(jsonTemp);
      //print(jsonObjectsList);
    }
    jsonObjects['results'] = jsonObjectsList;
    return jsonObjects;
    //print(jsonObjectsList);
    //print(jsonObjectsList.toString());
    /*final response = await _client.get(
        Uri.parse(getPath(path, params)),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(response.reasonPhrase);
    }*/
  }

  dynamic getDetail(String id) async {
    Iterable<QueryDocumentSnapshot> document = await events.get().then((value) {return value.docs.where((element) => element.reference.id == id);});
    Map<String, dynamic> jsonTemp = {};
    QueryDocumentSnapshot element = document.first;

    GeoPoint geoPoint = await element.reference.get().then((value) => (value.get('position')?? null));
    jsonTemp['id'] = element.reference.id;
    jsonTemp['creator'] = await element.reference.get().then((value) => (value.get('creator')?? ''));
    jsonTemp['title'] = await element.reference.get().then((value) => (value.get('title')?? ''));
    jsonTemp['type'] = await element.reference.get().then((value) => (value.get('type')?? ''));
    jsonTemp['imageUrl'] = await element.reference.get().then((value) => (value.get('imageUrl')?? ''));
    jsonTemp['description'] = await element.reference.get().then((value) => (value.get('description')?? ''));
    jsonTemp['latitude'] = geoPoint?.latitude;
    jsonTemp['longitude'] = geoPoint?.longitude;
    jsonTemp['videoUrl'] = await element.reference.get().then((value) => (value.get('videoUrl')?? ''));

    return jsonTemp;
  }

  dynamic getSearched(String searchTerm) async {
    Map<String, dynamic> jsonObjects = {};
    var jsonObjectsList = [];
    String description;
    String creator;
    String type;
    String title;
    List<QueryDocumentSnapshot> documents = await events.get().then((value) {return value.docs;});
    for(var element in documents) {
      if(await element.reference.get().then((value) {
          description = value.get('description');
          creator = value.get('creator');
          type = value.get('type');
          title = value.get('title');
          return (description.toLowerCase().contains(searchTerm.toLowerCase()) || creator.toLowerCase().contains(searchTerm.toLowerCase()) || type.toLowerCase().contains(searchTerm.toLowerCase()) || title.toLowerCase().contains(searchTerm.toLowerCase()));
      })){
        Map<String, dynamic> jsonTemp = {};
        GeoPoint geoPoint = await element.reference.get().then((value) => (value.get('position')?? null));
        jsonTemp['id'] = element.reference.id;
        jsonTemp['creator'] = creator;//await element.reference.get().then((value) => (value.get('creator')?? ''));
        jsonTemp['title'] = title;//await element.reference.get().then((value) => (value.get('title')?? ''));
        jsonTemp['type'] = type;//await element.reference.get().then((value) => (value.get('type')?? ''));
        jsonTemp['imageUrl'] = await element.reference.get().then((value) => (value.get('imageUrl')?? ''));
        jsonTemp['description'] = description;//await element.reference.get().then((value) => (value.get('description')?? ''));
        jsonTemp['latitude'] = geoPoint?.latitude;
        jsonTemp['longitude'] = geoPoint?.longitude;
        jsonTemp['videoUrl'] = await element.reference.get().then((value) => (value.get('videoUrl')?? ''));
        //print(jsonTemp);
        jsonObjectsList.add(jsonTemp);
      }
      //print(jsonObjectsList);
    }
    jsonObjects['results'] = jsonObjectsList;
    return jsonObjects;
  }

  dynamic getLatest() async {
    Map<String, dynamic> jsonObjects = {};
    var jsonObjectsList = [];
    List<QueryDocumentSnapshot> documents = await events.orderBy('date', descending: true).get().then((value) {return value.docs;});
    for(var element in documents) {
      Map<String, dynamic> jsonTemp = {};
      GeoPoint geoPoint = await element.reference.get().then((value) => (value.get('position')?? null));
      jsonTemp['id'] = element.reference.id;
      jsonTemp['creator'] = await element.reference.get().then((value) => (value.get('creator')?? ''));
      jsonTemp['title'] = await element.reference.get().then((value) => (value.get('title')?? ''));
      jsonTemp['type'] = await element.reference.get().then((value) => (value.get('type')?? ''));
      jsonTemp['imageUrl'] = await element.reference.get().then((value) => (value.get('imageUrl')?? ''));
      jsonTemp['description'] = await element.reference.get().then((value) => (value.get('description')?? ''));
      jsonTemp['latitude'] = geoPoint?.latitude;
      jsonTemp['longitude'] = geoPoint?.longitude;
      jsonTemp['videoUrl'] = await element.reference.get().then((value) => (value.get('videoUrl')?? ''));
      //print(jsonTemp);
      jsonObjectsList.add(jsonTemp);
      //print(jsonObjectsList);
    }
    jsonObjects['results'] = jsonObjectsList;
    return jsonObjects;
  }

  dynamic getBranded() async {
    Map<String, dynamic> jsonObjects = {};
    var jsonObjectsList = [];
    String type;
    List<QueryDocumentSnapshot> documents = await events.get().then((value) {return value.docs;});
    for(var element in documents) {
      type = await element.reference.get().then((value) => (value.get('type')?? ''));
      if(type == 'Brand'){
        Map<String, dynamic> jsonTemp = {};
        GeoPoint geoPoint = await element.reference.get().then((value) => (value.get('position')?? null));
        jsonTemp['id'] = element.reference.id;
        jsonTemp['creator'] = await element.reference.get().then((value) => (value.get('creator')?? ''));
        jsonTemp['title'] = await element.reference.get().then((value) => (value.get('title')?? ''));
        jsonTemp['type'] = type;//await element.reference.get().then((value) => (value.get('type')?? ''));
        jsonTemp['imageUrl'] = await element.reference.get().then((value) => (value.get('imageUrl')?? ''));
        jsonTemp['description'] = await element.reference.get().then((value) => (value.get('description')?? ''));
        jsonTemp['latitude'] = geoPoint?.latitude;
        jsonTemp['longitude'] = geoPoint?.longitude;
        jsonTemp['videoUrl'] = await element.reference.get().then((value) => (value.get('videoUrl')?? ''));
        //print(jsonTemp);
        jsonObjectsList.add(jsonTemp);
        //print(jsonObjectsList);
      }
    }
    jsonObjects['results'] = jsonObjectsList;
    return jsonObjects;
  }

  dynamic getNear(GeoPoint position) async {
    Map<String, dynamic> jsonObjects = {};
    var jsonObjectsList = [];

    // Create a geoFirePoint
    GeoFirePoint center = geo.point(latitude: position.latitude, longitude: position.longitude); //Milano latitude: 45.4642035, longitude: 9.189982
    //Stream<List<DocumentSnapshot>> documents = geo.collection(collectionRef: events)
    //    .within(center: center, radius: 50, field: 'position');
    List<QueryDocumentSnapshot> documents = await events.get().then((value) {return value.docs;});
    for(var element in documents) {
      GeoPoint geoPoint = await element.reference.get().then((value) => (value.get('position')?? null));
      print(center.distance(lat: geoPoint.latitude, lng: geoPoint.longitude));
      if(center.distance(lat: geoPoint.latitude, lng: geoPoint.longitude) <= 10.00) {
        Map<String, dynamic> jsonTemp = {};
        jsonTemp['id'] = element.reference.id;
        jsonTemp['creator'] = await element.reference.get().then((value) => (value.get('creator')?? ''));
        jsonTemp['title'] = await element.reference.get().then((value) => (value.get('title')?? ''));
        jsonTemp['type'] = await element.reference.get().then((value) => (value.get('type')?? ''));
        jsonTemp['imageUrl'] = await element.reference.get().then((value) => (value.get('imageUrl')?? ''));
        jsonTemp['description'] = await element.reference.get().then((value) => (value.get('description')?? ''));
        jsonTemp['latitude'] = geoPoint?.latitude;
        jsonTemp['longitude'] = geoPoint?.longitude;
        jsonTemp['videoUrl'] = await element.reference.get().then((value) => (value.get('videoUrl')?? ''));
        //print(jsonTemp);
        jsonObjectsList.add(jsonTemp);
      }
    }
    jsonObjects['results'] = jsonObjectsList;
    return jsonObjects;

    //List<QueryDocumentSnapshot> documents = await events.orderBy('date', descending: true).get().then((value) {return value.docs;});
    /*documents.listen((List<DocumentSnapshot> documentList) async {
      for(var element in documentList) {
        Map<String, dynamic> jsonTemp = {};
        GeoPoint geoPoint = await element.reference.get().then((value) => (value.get('position')?? null));
        jsonTemp['id'] = element.reference.id;
        jsonTemp['creator'] = await element.reference.get().then((value) => (value.get('creator')?? ''));
        jsonTemp['title'] = await element.reference.get().then((value) => (value.get('title')?? ''));
        jsonTemp['type'] = await element.reference.get().then((value) => (value.get('type')?? ''));
        jsonTemp['imageUrl'] = await element.reference.get().then((value) => (value.get('imageUrl')?? ''));
        jsonTemp['description'] = await element.reference.get().then((value) => (value.get('description')?? ''));
        jsonTemp['latitude'] = geoPoint?.latitude;
        jsonTemp['longitude'] = geoPoint?.longitude;
        jsonTemp['videoUrl'] = await element.reference.get().then((value) => (value.get('videoUrl')?? ''));
        //print(jsonTemp);
        jsonObjectsList.add(jsonTemp);
        //print(jsonObjectsList);
      }
      jsonObjects['results'] = jsonObjectsList;
      return jsonObjects;
    });*/
  }
}