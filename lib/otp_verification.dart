import 'package:donaterio/user_donation_form.dart';
import 'package:flutter/material.dart';

void main()
{
  runApp(MaterialApp(
    home: otp_verification(),
  ));
}

class otp_verification extends StatefulWidget {
  @override
  _otp_verificationState createState() => _otp_verificationState();
}

class _otp_verificationState extends State<otp_verification> {
  TextEditingController otpController = TextEditingController();
  final otp=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Verification'),
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
        key:otp,
        child: Padding(
          padding: EdgeInsets.all(10),
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
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  cursorColor: Colors.deepOrange,
                  controller: otpController,
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
                    labelText: 'OTP',
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
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: FlatButton(
                    textColor: Colors.white,
                    child: Text('Verify'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => user_donation_form()),
                      );
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
