import 'package:donaterio/res_location.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'volunteer_location.dart';

void main()
{
  runApp(registration());
}
class registration extends StatefulWidget {
  @override
  _registrationState createState() => _registrationState();
}

class _registrationState extends State<registration> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Register(),
    );
  }
}
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child:Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
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
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text('Donator'),
              ),
              Tab(
                child: Text('Volunteer'),
              ),
              Tab(
                child: Text('Restaurant'),
              ),
            ],
          ),
          title:Text('Register'),
        ),
        body: TabBarView(
          children: <Widget>[
            Donator(),
            Volunteer(),
            Restaurant(),
          ],
        ),
      ),
    );
  }
}
class Donator extends StatefulWidget {
  @override
  _DonatorState createState() => _DonatorState();
}

class _DonatorState extends State<Donator> {

  TextEditingController nameController = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController cpasswordcontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _donator=GlobalKey<FormState>();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final _firestore=Firestore.instance;
  String login_id,email,password,role;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _donator,
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
                  keyboardType: TextInputType.phone,
                  cursorColor: Colors.deepOrange,
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
                  obscureText: true,
                  cursorColor: Colors.deepOrange,
                  controller: passwordController,
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
                    labelText: 'Password',
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
                  controller: cpasswordcontroller,
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
                    labelText: 'Confirm Password',
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
                    child: Text('Register'),
                    onPressed: () async {
//                      print(emailcontroller.text);
//                      print(passwordController.text);
                      Pattern pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = new RegExp(pattern);

                    if(nameController.text.isEmpty)
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid name')));
                      }
                    else if(mobilecontroller.text.length!=10)
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid mobile no')));
                      }
                    else if(!regex.hasMatch(emailcontroller.text))
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid Email')));
                      }
                    else if(passwordController.text.length<6)
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid password')));
                      }
                    else if(cpasswordcontroller.text!=passwordController.text)
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid confirm password')));
                      }
                      else {
                        try {
                          final newuser = await _auth
                              .createUserWithEmailAndPassword(
                              email: emailcontroller.text,
                              password: passwordController.text);

                          if (newuser != null) {
                            login_id = newuser.user.uid;
                            email = emailcontroller.text;
                            password = passwordController.text;
                            role ="donator";
                            _firestore.collection('tbl_login').add({
                              'login_id': login_id,
                              'email': email,
                              'password': password,
                              'role': role,
                            });
                            _firestore.collection('tbl_donator').add({
                              'login_id': login_id,
                              'name': nameController.text,
                              'phone': mobilecontroller.text,
                              'email': email,
                            });
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Login()));
                          }
                        }
                        catch (e) {
                          print(e);
                          String error=e.toString().substring(17);
                          final snackBar = new SnackBar(
                              content: new Text(error),
                             );

                              Scaffold.of(context).showSnackBar(snackBar);

                        }
                      }

                    },
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class Volunteer extends StatefulWidget {
  @override
  _VolunteerState createState() => _VolunteerState();
}

class _VolunteerState extends State<Volunteer> {
  TextEditingController vnameController = TextEditingController();
  TextEditingController vmobilecontroller = TextEditingController();
  TextEditingController vemailcontroller = TextEditingController();
  TextEditingController vaddresscontroller = TextEditingController();
  TextEditingController vpasswordController = TextEditingController();
  TextEditingController vcpasswordcontroller = TextEditingController();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final _firestore=Firestore.instance;
  String vlogin_id,vname,vemail,vphone,vaddress;

  final _volunteer=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _volunteer,
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
                  controller: vnameController,
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
                  keyboardType: TextInputType.phone,
                  cursorColor: Colors.deepOrange,
                  controller: vmobilecontroller,
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
                  controller: vemailcontroller,
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
                  controller: vaddresscontroller,
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

                  keyboardType: TextInputType.multiline,
                  maxLength: null,
                  maxLines: null,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  obscureText: true,
                  cursorColor: Colors.deepOrange,
                  controller: vpasswordController,
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
                    labelText: 'Password',
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
                  controller: vcpasswordcontroller,
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
                    labelText: 'Confirm Password',
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
                    child: Text('Register'),
                    onPressed: () async{
                      Pattern pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = new RegExp(pattern);

                      if(vnameController.text.isEmpty)
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid name')));
                      }
                      else if(vmobilecontroller.text.length!=10)
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid mobile no')));
                      }
                      else if(!regex.hasMatch(vemailcontroller.text))
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid Email')));
                      }
                      else if(vaddresscontroller.text.isEmpty)
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter an address')));
                      }
                      else if(vpasswordController.text.length<6)
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid password')));
                      }
                      else if(vcpasswordcontroller.text!=vpasswordController.text)
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid confirm password')));
                      }
                      else {
                        try {
                          final newuser = await _auth
                              .createUserWithEmailAndPassword(
                              email: vemailcontroller.text,
                              password: vpasswordController.text);

                          if (newuser != null) {
                            _firestore.collection('tbl_login').add({
                              'login_id': newuser.user.uid,
                              'email': vemailcontroller.text,
                              'password': vpasswordController.text,
                              'role': "Volunteer",
                            });
                            vlogin_id = newuser.user.uid;
                            vname = vnameController.text;
                            vemail = vemailcontroller.text;
                            vphone = vmobilecontroller.text;
                            vaddress = vaddresscontroller.text;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>
                                    volunteer_location(login_id: vlogin_id,
                                        name: vname,
                                        phone: vphone,
                                        email:vemail,
                                        address: vaddress)));
                          }
                        }
                        catch (e) {
                          print(e);
                          String error=e.toString().substring(17);
                          final snackBar = new SnackBar(
                            content: new Text(error),
                          );

                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }
}
class Restaurant extends StatefulWidget {
  @override
  _RestaurantState createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  TextEditingController rnameController = TextEditingController();
  TextEditingController rmobilecontroller = TextEditingController();
  TextEditingController remailcontroller = TextEditingController();
  TextEditingController raddresscontroller = TextEditingController();
  TextEditingController rpasswordController = TextEditingController();
  TextEditingController rcpasswordcontroller = TextEditingController();
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final _firestore=Firestore.instance;

  String rlogin_id,rname,rphone,raddress,remail;

  final _restaurant=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _restaurant,
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
                  controller: rnameController,
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
                  validator: (value11) {
                    if (value11.isEmpty) {
                      return 'Please enter valid name';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(

                  cursorColor: Colors.deepOrange,
                  keyboardType: TextInputType.phone,
                  controller: rmobilecontroller,
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
                  validator: (value12) {
                    if (value12.length!=10) {
                      return 'Please enter valid mobile no';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  cursorColor: Colors.deepOrange,
                  keyboardType: TextInputType.emailAddress,
                  controller: remailcontroller,
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
                  validator: (value13) {
                    Pattern pattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(value13)) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  cursorColor: Colors.deepOrange,
                  controller: raddresscontroller,
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
                  validator: (value14) {
                    if (value14.isEmpty) {
                      return 'Please enter valid password';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLength: null,
                  maxLines: null,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  obscureText: true,
                  cursorColor: Colors.deepOrange,
                  controller: rpasswordController,
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
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Colors.deepOrange,
                    ),
                  ),
                  validator: (value15) {
                    if (value15.length<6) {
                      return 'Please enter min 6 digit password';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  cursorColor: Colors.deepOrange,
                  controller: rcpasswordcontroller,
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
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(
                      color: Colors.deepOrange,
                    ),
                  ),
                  validator: (value16) {
                    if (value16!=rpasswordController.text) {
                      return 'Please confirm password';
                    }
                    return null;
                  },
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
                    child: Text('Register'),
                    onPressed: () async{
                      Pattern pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = new RegExp(pattern);

                      if(rnameController.text.isEmpty)
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid name')));
                      }
                      else if(rmobilecontroller.text.length!=10)
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid mobile no')));
                      }
                      else if(!regex.hasMatch(remailcontroller.text))
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid Email')));
                      }
                      else if(raddresscontroller.text.isEmpty)
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter an address')));
                      }
                      else if(rpasswordController.text.length<6)
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid password')));
                      }
                      else if(rcpasswordcontroller.text!=rpasswordController.text)
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enter valid confirm password')));
                      }
                      else {
                        try {
                          final newuser = await _auth
                              .createUserWithEmailAndPassword(
                              email: remailcontroller.text,
                              password: rpasswordController.text);

                          if (newuser != null) {
                            _firestore.collection('tbl_login').add({
                              'login_id': newuser.user.uid,
                              'email': remailcontroller.text,
                              'password': rpasswordController.text,
                              'role': "Restaurant",
                            });
                            rlogin_id = newuser.user.uid;
                            rname = rnameController.text;
                            remail = remailcontroller.text;
                            rphone = rmobilecontroller.text;
                            raddress = raddresscontroller.text;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>
                                    res_location(login_id: rlogin_id,
                                        name: rname,
                                        phone: rphone,
                                        email: remail,
                                        address: raddress)));
                          }
                        }
                        catch (e) {
                          print(e);
                          String error=e.toString().substring(17);
                          final snackBar = new SnackBar(
                            content: new Text(error),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                      }

                    },
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }
}

