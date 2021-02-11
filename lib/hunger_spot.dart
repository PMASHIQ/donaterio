
import 'dart:ffi';
import 'dart:math' show cos, sqrt, asin;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donaterio/spot_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import 'location.dart';
void main()
{
  runApp(HungerSpot());
}
class HungerSpot extends StatefulWidget {
  @override
  _HungerSpotState createState() => _HungerSpotState();
}

class _HungerSpotState extends State<HungerSpot> {
  var userlatitude=0.0;
      var userlongitude=0.0;
  Firestore _firestore=Firestore.instance;

  void getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    userlatitude=position.latitude;
    userlongitude=position.longitude;
  }

  @override
  void initState()
  {
    getLocation();
    super.initState();
  }
  Future<QuerySnapshot> getdata() async
  {
    //getLocation();
    var now=DateTime.now();
    var date=DateFormat("dd-MM-yyy").format(now);
    var data=await _firestore.collection("tbl_hunger_spot").where('date',isEqualTo: date).getDocuments();
    //print(data.documents[0].data);
    return data;
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
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
        body: FutureBuilder(
          future: getdata(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.hasData)
              {
                QuerySnapshot data=snapshot.data;
                 return ListView.builder(
                  itemCount:data.documents.length,
                  itemBuilder: (BuildContext context,int index){
                    var distance=0.0;
                    var latitude=data.documents[index].data['latitude'];
                    var longitude=data.documents[index].data['longitude'];
                      var p = 0.017453292519943295;
                      var c = cos;
                      var a = 0.5 - c((latitude - userlatitude) * p)/2 +
                          c(userlatitude * p) * c(latitude * p) *
                              (1 - c((longitude - userlongitude) * p))/2;
                       distance=12742 * asin(sqrt(a));
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Colors.orangeAccent,
                                  Colors.black26,
                                ]
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height:180.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                        width: 320.0,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: <Color>[
                                                  Colors.orangeAccent,
                                                  Colors.yellowAccent,
                                                ])
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(
                                                'Location',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.blueGrey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Divider(color: Colors.black26,),
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(
                                                'Name : '+data.documents[index].data['place'],
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.black54
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text('distance : '+distance.toStringAsFixed(5)+' km',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.black54
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: RaisedButton(
                                                color: Colors.black26,
                                                onPressed: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>trace_location(lat:latitude,long:longitude)));
                                                },
                                                child: Text(
                                                  'View',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                  }
                );
              }
            else
              {
                return Center(child: CircularProgressIndicator());
              }
          }
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('Add'),
          icon: Icon(Icons.add_location),
          backgroundColor: Colors.orangeAccent,
          onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(builder: (context) =>spot_location()));
          },
        ),
      ),
    );
  }
}
