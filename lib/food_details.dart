import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donaterio/Notification.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
void mai()
{
  runApp(MaterialApp(
    home: NotificationDetails(),
  ));
}
class NotificationDetails extends StatefulWidget {
  String food_id;
  NotificationDetails({this.food_id});
  @override
  _DonatorProfileState createState() => _DonatorProfileState(food_id);
}

class _DonatorProfileState extends State<NotificationDetails> {
  String food_id;
  Firestore _firestore=Firestore.instance;
  _DonatorProfileState(this.food_id);
  TextEditingController date = TextEditingController();
  TextEditingController foodtype = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController description = TextEditingController();
  final profile=GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }
  Future<DocumentSnapshot> getData() async
  {
    print(food_id);
    SharedPreferences login=await SharedPreferences.getInstance();
    var data= await _firestore.collection("tbl_donator_food").document(food_id).get();
    //print(data.documents[0].data);
    return data;

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
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
              var fooddata=snapshot.data;
              date.text=fooddata["date"];
              foodtype.text=fooddata["food_category"];
              quantity.text=fooddata['quantity'];
              description.text=fooddata['Description'];
              place.text=fooddata['place'];
              return Form(
                key: profile,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            enabled: false,
                            style: TextStyle(
                              color: Colors.deepOrange,
                            ),
                            cursorColor: Colors.deepOrange,
                            controller: date,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.deepOrange),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.orange),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.orange),
                              ),
                              labelText: 'Date',
                              labelStyle: TextStyle(
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            enabled: false,
                            cursorColor: Colors.deepOrange,
                            style: TextStyle(
                              color: Colors.deepOrange,
                            ),
                            controller: foodtype,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.deepOrange),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.orange),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.orange),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.deepOrange,
                              ),
                              labelText: 'Food Type',
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            enabled: false,
                            cursorColor: Colors.deepOrange,
                            style: TextStyle(
                              color: Colors.deepOrange,
                            ),
                            controller: quantity,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.deepOrange),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.orange),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.orange),
                              ),
                              labelText: 'Food Qunatity',
                              labelStyle: TextStyle(
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            enabled: false,
                            style: TextStyle(
                              color: Colors.deepOrange,
                            ),
                            cursorColor: Colors.deepOrange,
                            controller: description,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.deepOrange),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.orange),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.orange),
                              ),
                              labelText: 'Description',
                              labelStyle: TextStyle(
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            enabled: false,
                            cursorColor: Colors.deepOrange,
                            style: TextStyle(
                              color: Colors.deepOrange,
                            ),
                            controller: place,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.deepOrange),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.orange),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.orange),
                              ),
                              labelText: 'Donator Location',
                              labelStyle: TextStyle(
                                color: Colors.deepOrange,
                              ),
                            ),
                            maxLength: null,
                            maxLines: null,
                          ),
                        ),
                        Container(
                            height: 50,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[
                                      Colors.red,
                                      Colors.orangeAccent,
                                    ])
                            ),
                            padding: EdgeInsets.all(10),
                            child: FlatButton(
                              textColor: Colors.white,
                              child: Text('Accept'),
                              onPressed: () async {
                                SharedPreferences login=await SharedPreferences.getInstance();
                                var now=DateTime.now();
                                var date=DateFormat("dd-MM-yyy").format(now);
                                var time= DateFormat("H:m:s").format(now);
                                _firestore.collection("tbl_donator_food").document(food_id).updateData({
                                  'status':"1"
                                });
                                _firestore.collection('tbl_volunteer_request').add({
                                  'food_id': food_id,
                                  'volunteer_id': login.get('login_id'),
                                  'date':date,
                                  'time':time,
                                });
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                    notification()), (Route<dynamic> route) => false);
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Request accepted')));

                              },
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          else
            {
              return Center(child: CircularProgressIndicator());
            }

        },
      ),
    );
  }
}
