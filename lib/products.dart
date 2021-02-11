import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donaterio/add_offer.dart';
import 'package:donaterio/add_product.dart';
import 'package:donaterio/spot_location.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'donated_full_details.dart';
void main()
{
  runApp(products());
}
class products extends StatefulWidget {
  @override
  _HungerSpotState createState() => _HungerSpotState();
}

class _HungerSpotState extends State<products> {
  Firestore _firestore=Firestore.instance;
  @override
  void initState()
  {
    super.initState();
  }
  Future<QuerySnapshot> getdata() async
  {
    SharedPreferences login=await SharedPreferences.getInstance();
    var data=await _firestore.collection('tbl_foods').where('res_id',isEqualTo: login.getString('login_id')).getDocuments();
    return data;
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Products'),
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
                return ListView.builder(
                  itemCount: data.documents.length,
                  itemBuilder: (BuildContext context,int index){
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 90.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Colors.deepOrange,
                                  Colors.orangeAccent,
                                ]
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height:70.0,
                                    child: FlatButton(
                                      onPressed: (){
                                        print('Donated Details');
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context)=>
                                                AddOffer(food_id:data.documents[index].documentID,food_name:data.documents[index].data['food_name'])));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child:Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: <Color>[
                                                    Colors.deepOrangeAccent,
                                                    Colors.white,
                                                  ])
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Divider(color: Colors.black26,),
                                              Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text(
                                                  data.documents[index].data['food_name'],
                                                  style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.brown
                                                  ),
                                                ),
                                              ),
                                              Divider(color: Colors.black26,
                                              ),
                                            ],
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
                  },
                );
              }
            else
              {
                return Center(child: CircularProgressIndicator());
              }

          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text('ADD PRODUCTS'),
          icon: Icon(Icons.add),
          backgroundColor: Colors.orangeAccent,
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>AddProduct()));
          },
        ),
      ),
    );
  }
}
