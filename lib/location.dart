import 'package:donaterio/hunger_spot.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'donator_home.dart';
import 'login.dart';
import 'main.dart';
import 'restaurant_home.dart';

void main() => runApp(trace_location());

class trace_location extends StatefulWidget {
  var lat,long;
  trace_location({this.lat,this.long});
  @override
  _MyAppState createState() => _MyAppState(lat,long);
}

class _MyAppState extends State<trace_location> {
  var lat,long;
  _MyAppState(this.lat,this.long);
  GoogleMapController mapController;
  Position position;
  Widget _child;
  var addresses;
  var first;
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
    final coordinates = new Coordinates(lat,long);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
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
      ),
    );
  }
  Set<Marker> createMarker()
  {
    return <Marker>[
      Marker(
        markerId: MarkerId("location"),
        position: LatLng(lat,long),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "Hunger Spot",),
      ),
    ].toSet();
  }
  Widget mapWidget()
  {
    return GoogleMap(
      mapType: MapType.normal,
      markers: createMarker(),
      initialCameraPosition: CameraPosition(
        target: LatLng(lat,long),
        zoom: 11.0,
      ),
      onMapCreated: (GoogleMapController controller)
      {
        mapController=controller;
      },
    );
  }
}

