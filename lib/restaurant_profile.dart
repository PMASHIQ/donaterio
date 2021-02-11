import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main()
{
  runApp(MaterialApp(
    home: RestaurantProfile(),
  ));
}
class RestaurantProfile extends StatefulWidget {
  @override
  _DonatorProfileState createState() => _DonatorProfileState();
}

class _DonatorProfileState extends State<RestaurantProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  final profile=GlobalKey<FormState>();
  Firestore _firestore=Firestore.instance;
  @override
  void initState() {
    super.initState();

  }
  Future<QuerySnapshot> getData() async
  {
    SharedPreferences login=await SharedPreferences.getInstance();
    var data= await _firestore.collection("tbl_retaurant").
    where('login_id',isEqualTo:login.getString('login_id')).getDocuments();
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
              QuerySnapshot data=snapshot.data;
              nameController.text=data.documents[0].data['name'];
              mobilecontroller.text=data.documents[0].data['phone'];
              emailcontroller.text=data.documents[0].data['email'];
              addresscontroller.text=data.documents[0].data['address'];
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
                                print(data.documents[0].documentID);
                                _firestore.collection("tbl_retaurant").document(data.documents[0].documentID).updateData({
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
              return Center(child: CircularProgressIndicator());
            }
        },
      ),
    );
  }
}
