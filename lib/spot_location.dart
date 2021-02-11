import 'package:donaterio/hunger_spot.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Volunteer_home.dart';
import 'donator_home.dart';
import 'login.dart';
import 'main.dart';
import 'restaurant_home.dart';

void main() => runApp(spot_location());

class spot_location extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<spot_location> {
  GoogleMapController mapController;
  Position position;
  Widget _child;
  var addresses;
  var first;
  String CurrentLocation="";
  String currentplace="";
  final _firestore=Firestore.instance;
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
    CurrentLocation='${first.locality},${first.subLocality},${first.featureName},${first.thoroughfare}';
    currentplace='${first.locality}';

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
          title: Text('Hunger Spot'),
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
            try {
              _firestore.collection('tbl_hunger_spot').add({
                'place': currentplace,
                'address':CurrentLocation,
                'latitude': position.latitude,
                'longitude': position.longitude,
                'date':DateFormat("dd-MM-yyy").format(now),
                'time': DateFormat("H:m:s").format(now),
              });
              SharedPreferences login=await SharedPreferences.getInstance();
              if(login.getString('role')=="donator")
                {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DHome()));
                }
              else if(login.getString('role')=="Volunteer")
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => VHome()));
              }
              else
                {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Home()));
                }
            }
            catch(e)
            {
              print(e);
            }
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

