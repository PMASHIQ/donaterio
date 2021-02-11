import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main()
{
  runApp(MaterialApp(
    home: VolunteerProfile(),
  ));
}
class VolunteerProfile extends StatefulWidget {
  @override
  _DonatorProfileState createState() => _DonatorProfileState();
}

class _DonatorProfileState extends State<VolunteerProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  final profile=GlobalKey<FormState>();
  String id;
  Firestore _firestore=Firestore.instance;
  FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }
  Future<QuerySnapshot> getData() async
  {
    SharedPreferences login=await SharedPreferences.getInstance();
    id=login.getString('login_id');
    var data= await _firestore.collection("tbl_volunteer").
    where('login_id',isEqualTo:id).getDocuments();
    //print(data.documents[0].data);
    return data;

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        future: getData(),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.hasData)
            {
              QuerySnapshot d=snapshot.data;
              nameController.text = d.documents[0].data['name'];
              mobilecontroller.text =d.documents[0].data['phone'];
              emailcontroller.text =d.documents[0].data['email'];
              addresscontroller.text=d.documents[0].data['address'];
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
                            style: TextStyle(
                              color: Colors.deepOrange,
                            ),
                            controller: nameController,
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
                                borderSide: new BorderSide(color: Colors.deepOrange),
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
                                borderSide: new BorderSide(color: Colors.deepOrange),
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
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            cursorColor: Colors.deepOrange,
                            style: TextStyle(
                              color: Colors.deepOrange,
                            ),
                            controller: addresscontroller,
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
                              labelText: 'Address',
                              labelStyle: TextStyle(
                                color: Colors.deepOrange,
                              ),
                            ),
                            maxLines: null,
                            maxLength: null,
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
                                print(emailcontroller.text);
                                SharedPreferences login=await SharedPreferences.getInstance();
                                print(login.getString('login_id'));
                                print(login.getString('role'));
                                print(d.documents[0].documentID);
                                _firestore.collection("tbl_volunteer").document(d.documents[0].documentID).updateData({
                                  'name':nameController.text,
                                  'phone':mobilecontroller.text,
                                  'email':emailcontroller.text,
                                  'address':addresscontroller.text,
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
              return Center(child: CircularProgressIndicator(),);
            }
        },
      ),
    );
  }
}
