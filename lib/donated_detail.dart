import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donaterio/spot_location.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'donated_full_details.dart';
void main()
{
  runApp(DonatedDetail());
}
class DonatedDetail extends StatefulWidget {
  @override
  _HungerSpotState createState() => _HungerSpotState();
}

class _HungerSpotState extends State<DonatedDetail> {
  Firestore _firestore=Firestore.instance;
  SharedPreferences login;
  String id;
  @override
  void initState()
  {
    super.initState();
    getlogin();

  }
  Future getlogin() async
  {
    login=await SharedPreferences.getInstance();
    id=login.getString('login_id');
    print(id);
  }
  Stream<QuerySnapshot>getData()
  {
    var data= _firestore.collection("tbl_donator_food").
    where('login_id',isEqualTo:id).orderBy('date',descending: true).orderBy('time',descending: false).snapshots();
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
          title: Text('Donated Details'),
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
        body: StreamBuilder(
          stream: getData(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot)
            {
            if(snapshot.hasData) {
              QuerySnapshot data=snapshot.data;
              return ListView.builder(
                itemCount:data.documents.length,
                itemBuilder:(BuildContext context,int index){
                  DocumentSnapshot document=snapshot.data.documents[index];
                  return
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 120.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Colors.deepOrange,
                                Colors.orangeAccent,
                              ]
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 100.0,
                                  child: FlatButton(
                                    onPressed: () {
                                      print('Donated Details');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>
                                              DonatedFullDetails(documentId:data.documents[index].documentID)));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                        width: 320.0,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                            gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: <Color>[
                                                  Colors.deepOrangeAccent,
                                                  Colors.white,
                                                ])
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Divider(color: Colors.black26,),
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text('date : '+document['date'],
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.brown
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(
                                                'Food Type : '+document['food_category'],
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.brown,
                                                ),
                                              ),
                                            ),
                                            Divider(color: Colors.black26,
                                            ),
                                          ],
                                        ),
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
                },

              );
            }
            else
              {
                return Center(child: CircularProgressIndicator());
              }
            }
        ),
      ),
    );
  }
}
