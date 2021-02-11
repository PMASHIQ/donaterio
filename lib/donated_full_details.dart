import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
void mai()
{
  runApp(MaterialApp(
    home: DonatedFullDetails(),
  ));
}
class DonatedFullDetails extends StatefulWidget {
  String documentId;
  DonatedFullDetails({this.documentId});
  @override
  _DonatorProfileState createState() => _DonatorProfileState(documentId);
}

class _DonatorProfileState extends State<DonatedFullDetails> {
  String documentId;
  _DonatorProfileState(this.documentId);
  TextEditingController date = TextEditingController();
  TextEditingController foodtype = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController place = TextEditingController();
  final Details=GlobalKey<FormState>();
  Firestore _firestore=Firestore.instance;
  String UserId;
  @override
  void initState() {
    super.initState();
  }
  Future<QuerySnapshot>getData() async
  {
    SharedPreferences login=await SharedPreferences.getInstance();
    UserId=login.getString('login_id');
    var data= await _firestore.collection("tbl_donator_food").
    where('login_id',isEqualTo:UserId).getDocuments();
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
        builder: (_,snapshot){
          if(snapshot.hasData)
            {
              QuerySnapshot data=snapshot.data;
              date.text=data.documents[0].data['date'];
              foodtype.text=data.documents[0].data['food_category'];
              quantity.text=data.documents[0].data['quantity'];
              place.text=data.documents[0].data['donated_place'];
              return Form(
                key: Details,
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
                              labelText: 'Donated Place',
                              labelStyle: TextStyle(
                                color: Colors.deepOrange,
                              ),
                            ),
                            maxLength: null,
                            maxLines: null,
                          ),
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
