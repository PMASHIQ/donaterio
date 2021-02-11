import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donaterio/donation_location.dart';
import 'package:donaterio/products.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main()
{
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AddOffer(),
  )
  );
}

class AddOffer extends StatefulWidget {
  String food_id;
  String food_name;
  AddOffer({this.food_id,this.food_name});
  @override
  _user_donation_formState createState() => _user_donation_formState(food_id,food_name);
}

class _user_donation_formState extends State<AddOffer> {
  String food_id;
  String food_name;
  String hotel,address;
  Firestore _firestore=Firestore.instance;
  _user_donation_formState(this.food_id,this.food_name);
  TextEditingController priceController = TextEditingController();
  TextEditingController offerController = TextEditingController();
  final addoffer=GlobalKey<FormState>();
  @override
  void initState()
  {
    super.initState();
  }
  Future<QuerySnapshot> getdata() async
  {
    SharedPreferences login=await SharedPreferences.getInstance();
    var data=await _firestore.collection('tbl_retaurant').where('login_id',isEqualTo: login.getString('login_id')).getDocuments();
    return data;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Add Offer',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
              hotel=data.documents[0].data['name'];
              address=data.documents[0].data['address'];
              return Form(
                key: addoffer,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(2),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Donaterio',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.deepOrangeAccent,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Righteous',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            cursorColor: Colors.deepOrange,
                            controller: priceController,
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
                              labelText: 'Price',
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLength: null,
                            maxLines: null,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            cursorColor: Colors.deepOrange,
                            controller: offerController,
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
                              labelText: 'Offer Price',
                              labelStyle: TextStyle(
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
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
                              child: Text('Submit'),
                              onPressed: () async{
                                SharedPreferences login=await SharedPreferences.getInstance();
                                var now=DateTime.now();
                                _firestore.collection('tbl_offer').add({
                                  'food_id':food_id,
                                  'hotel_id':login.getString('login_id'),
                                  'hotel':hotel,
                                  'address':address,
                                  'food_name':food_name,
                                  'MRP':priceController.text,
                                  'offer':offerController.text,
                                  'date':DateFormat('dd-MM-yyyy').format(now),
                                  'status':"0"
                                });
                                Navigator.pushReplacement(context, MaterialPageRoute(
                                    builder: (context) => products()));
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
    );;
  }
}
