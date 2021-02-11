import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Volunteer_home.dart';
import 'donator_home.dart';
import 'main.dart';
import 'register.dart';
import 'restaurant_home.dart';

void main()
{
  runApp(MaterialApp(
      home: Login()
  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth=FirebaseAuth.instance;
  final _firestore=Firestore.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _login=GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String role;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            //onPressed: () => Navigator.of(context).pop(),
            onPressed: (){
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Home()));
            },
          ),
          title: Text('Login'),
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
          key: _login,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontFamily: 'Righteous',

                          ),
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      cursorColor: Colors.deepOrange,
                      keyboardType: TextInputType.emailAddress,
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
                        labelText: 'User Name',
                        labelStyle: TextStyle(
                          color: Colors.deepOrange,
                        ),
                      ),
                      validator: (value) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (value.isEmpty ||!regex.hasMatch(value)) {
                          return 'Please enter valid username';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      obscureText: true,
                      cursorColor: Colors.deepOrange,
                      controller: passwordController,
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
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter valid password';
                        }
                        return null;
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: (){
                      //forgot password screen
                    },
                    textColor: Colors.black,
                    child: Text('Forgot Password'),
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
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: FlatButton(
                        textColor: Colors.white,
                        child: Text('Login'),
                        onPressed: () async {
                          print(nameController.text);
                          print(passwordController.text);
                          if (_login.currentState.validate())
                          {
                            try {
                              final user = await _auth.signInWithEmailAndPassword(
                                  email: nameController.text,
                                  password: passwordController.text);
                              if (user != null){
                                var data= _firestore.collection("tbl_login").
                                where('login_id',isEqualTo: user.user.uid).getDocuments()
                                    .then((QuerySnapshot snapshot){
                                  if(snapshot.documents.isNotEmpty)
                                  {
                                    print(snapshot.documents[0].data);
                                    role=snapshot.documents[0].data['role'];
                                    print(role);
                                    if(role.compareTo("donator")==0)
                                    {
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                          DHome()), (Route<dynamic> route) => false);
                                    }
                                    if(role.compareTo("Volunteer")==0)
                                    {
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                          VHome()), (Route<dynamic> route) => false);
                                    }
                                    if(role.compareTo("Restaurant")==0)
                                    {
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                          RHome()), (Route<dynamic> route) => false);

                                    }

                                  }
                                });

                              }

                            }
                            catch(e)
                            {
                              print(e);
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text('Not a valid user'),
                                    duration: Duration(seconds: 3),
                                  ));
                            }
                          }

                        },
                      )
                  ),
                  Container(
                      child: Row(
                        children: <Widget>[
                          Text('Does not have account?'),
                          FlatButton(
                            textColor: Colors.deepOrange,
                            child: Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              print("signup pressed");
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Register()),
                              );
                            },
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ))
                ],
              ),
          ),
        ),
    );
  }
}
