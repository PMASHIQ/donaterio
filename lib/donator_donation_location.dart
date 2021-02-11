
import 'dart:async';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'donator_home.dart';
import 'login.dart';
import 'main.dart';

void main() => runApp(donator_donation_location());

class donator_donation_location extends StatefulWidget {
  String category,desc,qty;
  donator_donation_location({this.category,this.desc,this.qty});
  @override
  _MyAppState createState() => _MyAppState(category,desc,qty);
}

class _MyAppState extends State<donator_donation_location> {
  final String serverToken = 'AAAAhDxWUIA:APA91bGuouB6wFo13UooXaUlkzBIruay5XtijGlKnQDs7cg3anxlkf9V6YuGQh4xcME_KZiq_9ogy5usT155_5tXA2ryNaZNlni2fRgXSTrJcJTHa5X0BEsY73R56qEGt-bb0nCG2pVx';
   FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final String token='d_B0dmtq8Kk:APA91bGAGhdhaB9Fx7Ohoj04p0q8VKQT6CVCyPBln2OCdDFTUBTDJ67-MCscTqB90JDmF4nO54JNusRoWTKnuwabU3IqQlLMxZ5C01A4F1lYpcuAYIEbtHdnuGa5p8H2cZLzXzrim54r';
  Firestore _firestore=Firestore.instance;
  String category,desc,qty;
  _MyAppState(this.category,this.desc,this.qty);
  GoogleMapController mapController;
  Position position;
  Widget _child;
  var addresses;
  var first;
  String CurrentLocation="";
  @override
  void initState()
  {
    getCurrentLocation();
    super.initState();
    //sendAndRetrieveMessage();

  }
  void getCurrentLocation() async
  {
    Position res=await Geolocator().getCurrentPosition();
    setState(() {
      position=res;
      _child=mapWidget();
    });
    final coordinates = new Coordinates(position.latitude, position.longitude);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
    CurrentLocation='${first.locality},${first.subLocality},${first.featureName},${first.thoroughfare}';
   // CurrentLocation='${first.subLocality}';
  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    var lat1=position.latitude;
    var long2=position.longitude;
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );
    _firestore.collection('tbl_volunteer').getDocuments().then((QuerySnapshot snapshot) async{
      for(int i=0;i<snapshot.documents.length;i++) {
        var lat2=snapshot.documents[i].data['latitude'];
        var long2=snapshot.documents[i].data['longitude'];
        print(i);
        await http.post(
          'https://fcm.googleapis.com/fcm/send',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverToken',
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': 'New donation available',
                'title': 'Donaterio',
                'icon':'myIcon',
                'sound':'mySound',
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              'to':snapshot.documents[i].data['token'],
            },
          ),
        );
      }
    });



    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );
    return completer.future;
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Donator location'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.red,
                      Colors.orangeAccent,
                    ])
            ),
          ),
        ),
        body:_child,
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Save Location'),
          icon: Icon(Icons.location_on),
          backgroundColor: Colors.orangeAccent,
          onPressed: () async{
            print(position.latitude);
            print(position.longitude);
            print(CurrentLocation);
            var now=DateTime.now();
            SharedPreferences login=await SharedPreferences.getInstance();
            sendAndRetrieveMessage();
            _firestore.collection('tbl_donator_food').add({
              'Description':desc,
              'food_category':category,
              'login_id':login.getString('login_id'),
              'quantity':qty,
              'status':"0",
              'latitude':position.latitude,
              'longitude':position.longitude,
              'place':CurrentLocation,
              'date':DateFormat("dd-MM-yyy").format(now),
              'time': DateFormat("H:m:s").format(now),
              'donated_place':""
            });


                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) =>DHome()));


          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
  Set<Marker> createMarker()
  {
    return <Marker>[
      Marker(
        markerId: MarkerId("location"),
        position: LatLng(position.latitude,position.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "current location",),
      ),
    ].toSet();
  }
  Widget mapWidget()
  {
    return GoogleMap(
      mapType: MapType.normal,
      markers: createMarker(),
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude,position.longitude),
        zoom: 11.0,
      ),
      onMapCreated: (GoogleMapController controller)
      {
        mapController=controller;

      },
    );
  }
}

