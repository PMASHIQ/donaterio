import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'donator_home.dart';
void main()
{
  runApp(MaterialApp(
    home: DonatorProfile(),
  ));
}
class DonatorProfile extends StatefulWidget {
  @override
  _DonatorProfileState createState() => _DonatorProfileState();
}

class _DonatorProfileState extends State<DonatorProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  final profile=GlobalKey<FormState>();
  String id;
  Firestore _firestore=Firestore.instance;
  FirebaseAuth _auth=FirebaseAuth.instance;


  @override
  void initState(){
    super.initState();
  }
  Future<QuerySnapshot> getData() async
  {
    SharedPreferences login=await SharedPreferences.getInstance();
    id=login.getString('login_id');
   var data= await _firestore.collection("tbl_donator").
    where('login_id',isEqualTo:id).getDocuments();
   //print(data.documents[0].data);
   return data;

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          //onPressed: () => Navigator.of(context).pop(),
          onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>DHome()));
          },
        ),
        title: Text('Profile'),
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
        future:getData(),
        builder:(BuildContext context,AsyncSnapshot snapshot) {
          if(snapshot.hasData) {
            QuerySnapshot d=snapshot.data;
            nameController.text=d.documents[0].data['name'];
            mobilecontroller.text=d.documents[0].data['phone'];
            emailcontroller.text=d.documents[0].data['email'];
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
                          //initialValue: d.documents[0].data['name'],
                          cursorColor: Colors.deepOrange,
                          style: TextStyle(
                            color: Colors.deepOrange,
                          ),
                          controller: nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.deepOrange),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.orange),
                            ),
                            labelText: 'Name',
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
                          style: TextStyle(
                            color: Colors.deepOrange,
                          ),
                          controller: mobilecontroller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.deepOrange),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.orange),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.deepOrange,
                            ),
                            labelText: 'Mobile No',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          cursorColor: Colors.deepOrange,
                          style: TextStyle(
                            color: Colors.deepOrange,
                          ),
                          controller: emailcontroller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.deepOrange),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.orange),
                            ),
                            labelText: 'E-mail',
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
                            child: Text('Edit'),
                            onPressed: () async{
                              print(nameController.text);
                              print(mobilecontroller.text);
                              print(emailcontroller.text);
                              //print(id);
                              SharedPreferences login=await SharedPreferences.getInstance();
                              print(login.getString('login_id'));
                              print(login.getString('role'));
                              print(d.documents[0].documentID);
                              _firestore.collection("tbl_donator").document(d.documents[0].documentID).updateData({
                                'name':nameController.text,
                                'phone':mobilecontroller.text,
                                'email':emailcontroller.text,
                              });
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text('profile updated successfully')));
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
        }
      ),
    );
  }
}
