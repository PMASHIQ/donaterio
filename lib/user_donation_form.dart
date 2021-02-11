import 'package:donaterio/donation_location.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
void main()
{
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: user_donation_form(),
  )
  );
}

class user_donation_form extends StatefulWidget {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseUser user;
  user_donation_form({this.user});
  @override
  _user_donation_formState createState() => _user_donation_formState(user);
}

class _user_donation_formState extends State<user_donation_form> {
  FirebaseUser user;
  _user_donation_formState(this.user);
  TextEditingController descController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  final donation_form=GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String FoodType='Food Category';
  String category,description,quantity;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
            'Donate',
          style: TextStyle(
            color: Colors.white,
          ),
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
      ),
      body: Form(
        key: donation_form,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Donaterio',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.deepOrangeAccent,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Righteous',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: Colors.deepOrange, style: BorderStyle.solid, width: 0.80),
                    ),
                    //alignment:Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: FoodType,
                          iconSize: 20,
                          elevation:25,
                          style: TextStyle(
                              color: Colors.deepOrange,
                          ),
                          onChanged: (String newValue) {
                            setState(()
                            {
                              FoodType = newValue;
                            }
                            );
                          },
                          items: <String>['Food Category','BreakFast', 'Lunch', 'Dinner', 'Snacks']
                              .map<DropdownMenuItem<String>>((String value)
                          {
                            return DropdownMenuItem<String>
                              (
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    cursorColor: Colors.deepOrange,
                    controller: descController,
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
                      labelText: 'Description',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLength: null,
                    maxLines: null,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    cursorColor: Colors.deepOrange,
                    controller: qtyController,
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
                      labelText: 'Quantity Per Person',
                      labelStyle: TextStyle(
                        color: Colors.deepOrange,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
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
                      child: Text('Donate'),
                      onPressed: () {
                        print(descController.text);
                        print(qtyController.text);
                        print(FoodType);
                        print(user.phoneNumber);
                        category=FoodType;
                        description=descController.text;
                        quantity=qtyController.text;
                        var q=int.parse(qtyController.text);
                        if(q<=10) {
                          if (FoodType.isNotEmpty && description.isNotEmpty &&
                              quantity.isNotEmpty &&
                              user.phoneNumber.isNotEmpty) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    donation_location(user: user,
                                        category: category,
                                        desc: description,
                                        qty: quantity)));
                          }
                          else {
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('Please fill the form'),
                                  duration: Duration(seconds: 3),
                                ));
                          }
                        }
                        else
                          {
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('quantity greater than 10, please register to donate'),
                                  duration: Duration(seconds: 3),
                                ));
                          }

                      },
                    )
                ),

              ],
            ),
          ),
        ),
      ),
    );;
  }
}
