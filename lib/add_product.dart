import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donaterio/products.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
void mai()
{
  runApp(MaterialApp(
    home: AddProduct(),
  ));
}
class AddProduct extends StatefulWidget {
  @override
  _DonatorProfileState createState() => _DonatorProfileState();
}
class _DonatorProfileState extends State<AddProduct> {
  TextEditingController namecontroller = TextEditingController();
  final product=GlobalKey<FormState>();
  Firestore _firestore=Firestore.instance;
  @override
  void initState()
  {
    super.initState();
    getCurrentUser();

  }
  void getCurrentUser() async
  {
      SharedPreferences login=await SharedPreferences.getInstance();
      print(login.getString('login_id'));
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
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
      body: Form(
        key: product,
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
                    style: TextStyle(
                      color: Colors.deepOrange,
                    ),
                    controller: namecontroller,
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
                      labelText: 'Food Name',
                      labelStyle: TextStyle(
                        color: Colors.deepOrange,
                      ),
                    ),
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
                      child: Text('Submit'),
                      onPressed: () async{
                        SharedPreferences login=await SharedPreferences.getInstance();
                        _firestore.collection('tbl_foods').add({
                          'res_id':login.getString('login_id'),
                          'food_name': namecontroller.text,
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
      ),
    );
  }
}
