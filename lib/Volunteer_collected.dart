import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donaterio/spot_location.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'collected_food_details.dart';
import 'donated_full_details.dart';
void main()
{
  runApp(CollectedDetails());
}
class CollectedDetails extends StatefulWidget {
  @override
  _HungerSpotState createState() => _HungerSpotState();
}

class _HungerSpotState extends State<CollectedDetails> {
  Firestore _firestore=Firestore.instance;
  @override
  Future<QuerySnapshot> getdata() async
  {
    SharedPreferences login=await SharedPreferences.getInstance();
    var data=_firestore.collection("tbl_volunteer_request").where("volunteer_id",isEqualTo: login.getString('login_id')).getDocuments();
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
          title: Text('Collected Details'),
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
                  itemCount: data.documents.length,
                  itemBuilder: (BuildContext context,int index){
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 80.0,
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
                            child:SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height:60.0,
                                    child: FlatButton(
                                      onPressed: (){
                                        print('Donated Details');
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>CollectedFoodDetails(food_id:data.documents[index].data['food_id'])));
                                      },
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
                                                    Colors.deepOrangeAccent,
                                                    Colors.white,
                                                  ])
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text(
                                                  'Date : '+data.documents[index].data['date'],
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.brown
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text(
                                                  'Time : '+data.documents[index].data['time'],
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
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

          },
        ),
      ),
    );
  }
}
