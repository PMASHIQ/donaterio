import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
void mai()
{
  runApp(MaterialApp(
    home: CollectedFoodDetails(),
  ));
}
class CollectedFoodDetails extends StatefulWidget {
  String food_id;
  CollectedFoodDetails({this.food_id});
  @override
  _DonatorProfileState createState() => _DonatorProfileState(food_id);
}

class _DonatorProfileState extends State<CollectedFoodDetails> {
  String food_id;
  Firestore _firestore=Firestore.instance;
  _DonatorProfileState(this.food_id);
  TextEditingController date = TextEditingController();
  TextEditingController foodtype = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController donatedplace=TextEditingController();
  final profile=GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }
  Future<DocumentSnapshot> getdata() async
  {
    var data=_firestore.collection("tbl_donator_food").document(food_id).get();
   // QuerySnapshot donator=await _firestore.collection("tbl_donator").where('login_id',isEqualTo: data["login_id"]).getDocuments();
    return data;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Details'),
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
              var data=snapshot.data;
              date.text=data["date"];
              foodtype.text=data["food_category"];
              quantity.text=data["quantity"];
              place.text=data["place"];
              donatedplace.text=data["donated_place"];
            _firestore.collection("tbl_donator").
            where('login_id',isEqualTo: data["login_id"]).getDocuments()
                .then((QuerySnapshot snapshot){
                  mobile.text=snapshot.documents[0].data['phone'];
                  name.text=snapshot.documents[0].data['name'];
            });
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
                            cursorColor: Colors.deepOrange,
                            controller: name,
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
                              labelText: 'Donator Name',
                              labelStyle: TextStyle(
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            cursorColor: Colors.deepOrange,
                            controller: mobile,
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
                              labelText: 'Mobile No',
                              labelStyle: TextStyle(
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            cursorColor: Colors.deepOrange,
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
                              labelText: 'Donator Place',
                              labelStyle: TextStyle(
                                color: Colors.deepOrange,
                              ),
                            ),
                            maxLength: null,
                            maxLines: null,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            cursorColor: Colors.deepOrange,
                            controller: foodtype,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.deepOrange),
                              ),
                              enabledBorder: OutlineInputBorder(
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
                            cursorColor: Colors.deepOrange,
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
                            cursorColor: Colors.deepOrange,
                            controller: donatedplace,
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
                              labelText: 'Donated Place',
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
                              child: Text('Update'),
                              onPressed: () {
                                _firestore.collection("tbl_donator_food").document(food_id).updateData({
                                  'donated_place':donatedplace.text,
                                });
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Updated successfully')));
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
