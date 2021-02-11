import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donaterio/Notification.dart';
import 'package:donaterio/donated_details.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Volunteer_collected.dart';
import 'donator_profile.dart';
import 'hunger_spot.dart';
import 'login.dart';
import 'main.dart';
import 'user_donate.dart';
import 'volunteer_profile.dart';
void main() => runApp(VolunteerHome());

class VolunteerHome extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<VolunteerHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: VHome()
    );
  }
}
class VHome extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<VHome> {
  String volunteer_document_id;
  var userlatitude=0.0;
  var userlongitude=0.0;
  SharedPreferences login;
  final FirebaseMessaging _firebaseMessaging=FirebaseMessaging();
  StreamController<int> _events;
  final _auth=FirebaseAuth.instance;
  Firestore _firestore=Firestore.instance;
  FirebaseUser loggedUser;
  String User;
  String UserRole;
  int counter=0;
  void initState() {
    super.initState();
    _events = new StreamController<int>();
    _events.add(counter);
    getCurrentUser();
  }
  Future _incrementCounter() async {
    counter=0;
    _events.add(0);
    var now=DateTime.now();
    var date=DateFormat("dd-MM-yyy").format(now);
    login=await SharedPreferences.getInstance();
    QuerySnapshot location=await _firestore.collection('tbl_volunteer').where('login_id',isEqualTo: login.getString('login_id')).getDocuments();
    userlatitude=location.documents[0].data['latitude'];
    userlongitude=location.documents[0].data['longitude'];
    QuerySnapshot data=await _firestore.collection("tbl_donator_food").where('date',isEqualTo: date).where('status',isEqualTo: '0').getDocuments();
    for(int i=0;i<data.documents.length;i++)
      {
        var latitude=data.documents[i].data['latitude'];
        var longitude=data.documents[i].data['longitude'];
        var distance=0.0;
        var p = 0.017453292519943295;
        var c = cos;
        var a = 0.5 - c((latitude - userlatitude) * p)/2 +
            c(userlatitude * p) * c(latitude * p) *
                (1 - c((longitude - userlongitude) * p))/2;
        distance=12742 * asin(sqrt(a));
        print(distance);
        if(distance<5)
          {
            counter=counter+1;
          }
      }
    //counter=data.documents.length;
    _events.add(counter);

  }
  void setupnotification() 
  {
    _firebaseMessaging.getToken().then((token) async
    {
      print(token);
      login=await SharedPreferences.getInstance();
      QuerySnapshot volunteer=await _firestore.collection('tbl_volunteer').where('login_id',isEqualTo: login.getString('login_id')).getDocuments();
      volunteer_document_id=volunteer.documents[0].documentID;
      _firestore.collection('tbl_volunteer').document(volunteer_document_id).updateData({
        'token':token,
      });
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        setState(() {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>notification()));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        setState(() {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>notification()));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        setState(() {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>notification()));
        });
      },
    );
  }
  void getCurrentUser() async
  {
    login=await SharedPreferences.getInstance();
    try
    {
      final user = await _auth.currentUser();

      if (user != null) {
        loggedUser = user;
        _firestore.collection("tbl_login").
        where('login_id',isEqualTo: loggedUser.uid).getDocuments()
            .then((QuerySnapshot snapshot) {
          if (snapshot.documents.isNotEmpty) {
            //print(snapshot.documents[0].data['role']);
            UserRole=snapshot.documents[0].data['role'];
            login.setString('role',UserRole);
          }
        });
        print(loggedUser.email);
        login.setString('login_id',loggedUser.uid);
      }
    }
    catch(e)
    {
      print(e);
    }
    setupnotification();
  }
  Future<QuerySnapshot> getoffer() async
  {
    var now=DateTime.now();
    var date=DateFormat('dd-MM-yyyy').format(now);
    var data=await _firestore.collection('tbl_offer').where('date',isEqualTo: date).getDocuments();
    return data;
  }
  Future<QuerySnapshot> getfood() async
  {
    var now=DateTime.now();
    var date=DateFormat('dd-MM-yyyy').format(now);
    var data=await _firestore.collection('tbl_low_food').where('date',isEqualTo: date).getDocuments();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences;
   _incrementCounter();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          new Stack(
            children: <Widget>[
              new IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: ()
                  {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>notification()));
              }
              ),
               new Positioned(
                right: 11,
                top: 11,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: StreamBuilder<Object>(
                    stream: _events.stream,
                    builder: (context, snapshot) {
                      return Text(
                          '$counter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        );
                    }
                  ),
                ),
              ) //: new Container()
            ],
          ),
        ],
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
      drawer: Drawer(
        child:ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.red,
                    Colors.orangeAccent,
                  ],
                ),
              ),
              child:Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/donaterio.jpeg'),
                    radius: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Donaterio',
                      style:TextStyle(
                        fontSize: 17.0,
                        fontFamily:'Righteous',
                        color: Colors.yellowAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomList(Icons.perm_identity,'Profile',()=>{
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>VolunteerProfile())),
            }),
            CustomList(Icons.transfer_within_a_station,'Collected',()=>{
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>CollectedDetails())),
            }),
            CustomList(Icons.location_on,'Hunger Spot',()=>{
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>HungerSpot())),
            }),
            CustomList(Icons.share,'Share',()=>{}),
            CustomList(Icons.help,'Help',()=>{}),
            CustomList(Icons.close,'Logout',() async =>{
              _auth.signOut(),
              preferences = await SharedPreferences.getInstance(),
              preferences.clear(),
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context)=>Home())),

            }),
          ],
        ),
      ),
      body: DoubleBackToCloseApp(
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.red,
                      Colors.orangeAccent,
                    ])
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 300.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Colors.orangeAccent,
                                  Colors.white,
                                ])
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Todays Offers',
                                  style: TextStyle(
                                    color: Colors.brown,
                                    letterSpacing: 2.0,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Righteous',
                                  ),
                                ),
                                Divider(
                                  color: Colors.white,
                                ),
                                Container(
                                  height:200.0,
                                  child: FutureBuilder(
                                    future: getoffer(),
                                    builder: (BuildContext context,AsyncSnapshot snapshot){
                                      QuerySnapshot temp=snapshot.data;
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                      else if(snapshot.data==null)
                                      {
                                        return Center(
                                          child: Text('No Offers',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      }
                                      else if(temp.documents.length==0)
                                      {
                                        return Center(
                                          child: Text('No Offers',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      }
                                      else if(snapshot.hasData)
                                      {
                                        QuerySnapshot offer=snapshot.data;
                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: offer.documents.length,
                                          itemBuilder: (BuildContext context,int index){
                                            return Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Container(
                                                width: 320.0,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors: <Color>[
                                                          Colors.orangeAccent,
                                                          Colors.yellowAccent,
                                                        ])
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Text(
                                                        'Hotel : '+offer.documents[index].data['hotel'],
                                                        style: TextStyle(
                                                          fontSize: 20.0,
                                                          color: Colors.blueGrey,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Divider(color: Colors.black26,),
                                                    Padding(
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Text(
                                                        offer.documents[index].data['food_name'],
                                                        style: TextStyle(
                                                            fontSize: 20.0,
                                                            color: Colors.black54
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Text(
                                                        ' RS : '+offer.documents[index].data['MRP'],
                                                        style: TextStyle(
                                                            fontSize: 17.0,
                                                            color: Colors.black54
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(3.0),
                                                      child: Text(
                                                        'Offer Price : RS:'+offer.documents[index].data['offer'],
                                                        style: TextStyle(
                                                            fontSize: 17.0,
                                                            color: Colors.black54
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(2.0),
                                                      child: RaisedButton(
                                                        color: Colors.black26,
                                                        onPressed: (){

                                                        },
                                                        child: Text(
                                                          'View More',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                      else
                                      {
                                        return Center(child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 300.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Colors.orangeAccent,
                                  Colors.white,
                                ])
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Free Foods',
                                  style: TextStyle(
                                    color: Colors.brown,
                                    letterSpacing: 2.0,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Righteous',
                                  ),
                                ),
                                Divider(
                                  color: Colors.white,
                                ),
                                Container(
                                  height:200.0,
                                  child: FutureBuilder(
                                    future: getfood(),
                                    builder: (BuildContext context,AsyncSnapshot snapshot){
                                      QuerySnapshot temp=snapshot.data;
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                      else if(snapshot.data==null)
                                      {
                                        return Center(
                                          child: Text('No Donations',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      }
                                      else if(temp.documents.length==0)
                                      {
                                        return Center(
                                          child: Text('No Donations',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      }
                                      else if(snapshot.hasData)
                                      {
                                        QuerySnapshot food=snapshot.data;
                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: food.documents.length,
                                          itemBuilder: (BuildContext context,int index)
                                          {
                                            TimeOfDay snow = TimeOfDay.now();
                                            var nowInMinutes = snow.hour * 60 + snow.minute+15;
                                            print(nowInMinutes);
                                            var preminute=food.documents[index].data['minute'];
                                            var diff=nowInMinutes-preminute;
                                            print(diff);
                                            if(diff>30)
                                            {
                                              return Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Container(
                                                  width: 320.0,
                                                  child: Center(
                                                    child: Text('Donation Expired',
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.blueGrey,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            else
                                            {
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: 320.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                                      gradient: LinearGradient(
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                          colors: <Color>[
                                                            Colors.orangeAccent,
                                                            Colors.yellowAccent,
                                                          ])
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.all(3.0),
                                                        child: Text(
                                                          'Mobile No : '+food.documents[index].data['mobile_no'],
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            color: Colors.blueGrey,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(color: Colors.black26,),
                                                      Padding(
                                                        padding: const EdgeInsets.all(3.0),
                                                        child: Text(
                                                          'Food Type : '+food.documents[index].data['food_category'],
                                                          style: TextStyle(
                                                              fontSize: 17.0,
                                                              color: Colors.black54
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(3.0),
                                                        child: Text(
                                                          'Quantity For  : '+food.documents[index].data['quantity']+' Person',
                                                          style: TextStyle(
                                                              fontSize: 17.0,
                                                              color: Colors.black54
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(3.0),
                                                        child: Text(
                                                          'Location  : '+food.documents[index].data['place'],
                                                          style: TextStyle(
                                                              fontSize: 17.0,
                                                              color: Colors.black54
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: RaisedButton(
                                                          color: Colors.black26,
                                                          onPressed: (){

                                                          },
                                                          child: Text(
                                                            'View More',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 10.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        );
                                      }
                                      else
                                      {
                                        return Center(child: CircularProgressIndicator());
                                      }

                                    },
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
      ),
    );

  }

}

class CustomList extends StatelessWidget{

  IconData icon;
  String text;
  Function onTap;

  CustomList(this.icon,this.text,this.onTap);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.orangeAccent,
      onTap: onTap,

      child: Container(

        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_right),
          ],
        ),
      ),
    );
  }

}
