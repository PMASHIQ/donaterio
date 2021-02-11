import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donaterio/add_product.dart';
import 'package:donaterio/spot_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'donated_full_details.dart';
import 'food_details.dart';
void main()
{
  runApp(notification());
}
class notification extends StatefulWidget {
  @override
  _HungerSpotState createState() => _HungerSpotState();
}

class _HungerSpotState extends State<notification> {
  var userlatitude;
  var userlongitude;
  Firestore _firestore=Firestore.instance;
  SharedPreferences login;
  @override
  Future<QuerySnapshot> getData() async
  {
    login=await SharedPreferences.getInstance();
    var now=DateTime.now();
    var date=DateFormat("dd-MM-yyy").format(now);
    QuerySnapshot location=await _firestore.collection('tbl_volunteer').where('login_id',isEqualTo: login.getString('login_id'))
        .getDocuments();
    userlatitude=location.documents[0].data['latitude'];
    userlongitude=location.documents[0].data['longitude'];
    var data= await _firestore.collection("tbl_donator_food").where('date',isEqualTo: date).where('status',isEqualTo: '0').getDocuments();
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
          title: Text('Notifications'),
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
          future: getData(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.hasData)
              {
                QuerySnapshot data=snapshot.data;
                        return ListView.builder(
                          itemCount:data.documents.length,
                          itemBuilder:(BuildContext context,int index){
                            var distance=0.0;
                            var latitude=data.documents[index].data['latitude'];
                            var longitude=data.documents[index].data['longitude'];
                            var p = 0.017453292519943295;
                            var c = cos;
                            var a = 0.5 - c((latitude - userlatitude) * p)/2 +
                              c(userlatitude * p) * c(latitude * p) *
                              (1 - c((longitude - userlongitude) * p))/2;
                              distance=12742 * asin(sqrt(a));
                              print(index);
                              print(distance);
                              if(distance<5) {
                                return Container(
                                  height: 80.0,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 80.0,
                                          child: FlatButton(
                                            onPressed: () {
                                              print('Donated Details');
                                              String id=data.documents[index].documentID;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NotificationDetails(food_id:id)));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  5.0),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .all(
                                                        Radius.circular(10.0)),
                                                    gradient: LinearGradient(
                                                        begin: Alignment
                                                            .topLeft,
                                                        end: Alignment
                                                            .bottomLeft,
                                                        colors: <Color>[
                                                          Colors.deepOrange,
                                                          Colors.orangeAccent,
                                                        ])
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      8.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Column(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .only(
                                                                left: 15.0,
                                                                top: 0.0,
                                                                right: 0.0,
                                                                bottom: 0.0),
                                                            child: Text(
                                                              'New donation vailable in your location',
                                                              style: TextStyle(
                                                                  fontSize: 15.0,
                                                                  color: Colors
                                                                      .brown
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .all(3.0),
                                                            child: Text(
                                                              distance
                                                                  .toStringAsFixed(
                                                                  5) + ' km',
                                                              style: TextStyle(
                                                                fontSize: 18.0,
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              else
                                {
                                  return Container();
                                }

                            }
                        );
                        //}
                // }
              }
            else
              {
                return Center(child: CircularProgressIndicator());
              }
          },

        ),
      ),
    );
  }
}
