import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';

void main() => runApp(res_location());

class res_location extends StatefulWidget {
  String login_id,name,phone,email,address;
  res_location({this.login_id,this.name,this.phone,this.email,this.address});
  @override
  _MyAppState createState() => _MyAppState(login_id,name,phone,email,address);
}

class _MyAppState extends State<res_location> {
  String login_id,name,phone,email,address;
  _MyAppState(this.login_id,this.name,this.phone,this.email,this.address);
  GoogleMapController mapController;
  Position position;
  Widget _child;
  var addresses;
  var first;
  String CurrentLocation="";
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
          title: Text('Restaurant Location'),
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
            _firestore.collection('tbl_retaurant').add({
              'login_id':login_id,
              'name':name,
              'phone':phone,
              'email':email,
              'address':address,
              'latitude':position.latitude,
              'longitude':position.longitude,
            });
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>Login()));
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

