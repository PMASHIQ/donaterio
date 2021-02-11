import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donaterio/restaurant_profile.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:donaterio/donated_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'donator_profile.dart';
import 'hunger_spot.dart';
import 'login.dart';
import 'offers.dart';
import 'products.dart';
import 'user_donate.dart';
void main() => runApp(RestaurantHome());

class RestaurantHome extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<RestaurantHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RHome()
    );
  }
}
class RHome extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<RHome> {
  final _auth=FirebaseAuth.instance;
  FirebaseUser loggedUser;
  Firestore _firestore=Firestore.instance;
  String User;
  String UserRole;
  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getCurrentUser() async
  {
    try
    {
      final user = await _auth.currentUser();
      SharedPreferences login=await SharedPreferences.getInstance();
      if (user != null) {
        loggedUser = user;
        //print(loggedUser.email);
        _firestore.collection("tbl_login").
        where('login_id',isEqualTo: loggedUser.uid).getDocuments()
            .then((QuerySnapshot snapshot) {
          if (snapshot.documents.isNotEmpty) {
            //print(snapshot.documents[0].data['role']);
            UserRole=snapshot.documents[0].data['role'];
            login.setString('role',UserRole);
          }
        });
        login.setString('login_id',loggedUser.uid);
        User=login.getString('login_id');
        //print(User);
      }
    }
    catch(e)
    {
      print(e);
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
    var data=await _firestore.collection('tbl_low_food').where('date',isEqualTo: date).getDocuments();
    return data;
  }
  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
                  MaterialPageRoute(builder: (context)=>RestaurantProfile())),
            }),
            CustomList(Icons.fastfood,'Products',()=>{
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>products())),
            }),
            CustomList(Icons.local_offer,'Offers',()=>{
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>offers())),
            }),
            CustomList(Icons.share,'Share',()=>{}),
            CustomList(Icons.help,'Help',()=>{}),
            CustomList(Icons.close,'Logout',() async =>{
              _auth.signOut(),
              preferences = await SharedPreferences.getInstance(),
              preferences.clear(),
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context)=>Login())),
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
