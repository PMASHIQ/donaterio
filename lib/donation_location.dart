

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'login.dart';
import 'main.dart';

void main() => runApp(donation_location());

class donation_location extends StatefulWidget {
  FirebaseUser user;
  String category,desc,qty;
  donation_location({this.user,this.category,this.desc,this.qty});
  @override
  _MyAppState createState() => _MyAppState(user,category,desc,qty);
}

class _MyAppState extends State<donation_location> {
  Firestore _firestore=Firestore.instance;
  FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseUser user;
  String category,desc,qty;
  _MyAppState(this.user,this.category,this.desc,this.qty);
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
    //CurrentLocation='${first.locality},${first.subLocality},${first.featureName},${first.thoroughfare}';
    CurrentLocation='${first.subLocality}';
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
          onPressed: (){
            print(position.latitude);
            print(position.longitude);
            print(CurrentLocation);
            var now=DateTime.now();
            TimeOfDay snow = TimeOfDay.now();
            var nowInMinutes = now.hour * 60 + now.minute;
            _firestore.collection('tbl_low_food').add({
              'Description':desc,
              'food_category':category,
              'mobile_no':user.phoneNumber,
              'quantity':qty,
              'requests':"0",
              'latitude':position.latitude,
              'longitude':position.longitude,
              'place':CurrentLocation,
              'date':DateFormat("dd-MM-yyy").format(now),
              'time': DateFormat("H:m:s").format(now),
              'minute':nowInMinutes,
              'status':"0"
            });
//            Navigator.pushReplacement(context,
//                MaterialPageRoute(builder: (context) =>Home()));
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                Home()), (Route<dynamic> route) => false);
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

