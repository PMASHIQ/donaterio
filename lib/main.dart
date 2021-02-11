import 'dart:ffi';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donaterio/AskForPermission.dart';
import 'package:donaterio/register.dart';
import 'package:donaterio/restaurant_home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_intent/android_intent.dart';
import 'Volunteer_home.dart';
import 'donator_home.dart';
import 'hunger_spot.dart';
import 'login.dart';
import 'user_donate.dart';
import 'package:geolocator/geolocator.dart';
void main() async{
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Firestore _firestore=Firestore.instance;
  void initState()
  {
    super.initState();
    getuser();
  }
  Future getuser() async
  {
    SharedPreferences login=await SharedPreferences.getInstance();
    if(login.getString('role')=="donator")
    {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          DHome()), (Route<dynamic> route) => false);
    }
     if(login.getString('role')=="Volunteer")
      {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            VHome()), (Route<dynamic> route) => false);
      }
    if(login.getString('role')=="Restaurant")
    {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          RHome()), (Route<dynamic> route) => false);
    }
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
    var data=await _firestore.collection('tbl_low_food').where('date',isEqualTo: date).where('status',isEqualTo: "0").getDocuments();
    return data;
  }
  /*Check if gps service is enabled or not*/
  Future _gpsService() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      _checkGps();
      return null;
    } else
      return true;
  }
  /*Show dialog if GPS not enabled and open settings location*/
  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Can't get gurrent location"),
                content:const Text('Please make sure you enable GPS and try again'),
                actions: <Widget>[
                  FlatButton(child: Text('Ok'),
                      onPressed: (){
                        final AndroidIntent intent = AndroidIntent(
                            action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                        intent.launch();
                        Navigator.of(context, rootNavigator: true).pop();
                        _gpsService();
                      })],
              );
            });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    //getuser();
    _gpsService();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donaterio',
          style: TextStyle(
            fontFamily: 'Righteous',
            fontSize: 20.0,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          FlatButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => user_donate()),
              );
            //AuthService().handleAuth();
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Donate',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
            ),
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
            CustomList(Icons.dvr,'About Us',()=>{}),
            CustomList(Icons.location_on,'Hunger Spot',()=>{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=>HungerSpot())),
            }),
            CustomList(Icons.share,'Share',()=>{}),
            CustomList(Icons.help,'Help',()=>{}),
          ],
        ),
      ),
      body: SafeArea(
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
