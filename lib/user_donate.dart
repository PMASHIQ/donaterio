
import 'package:donaterio/otp_verification.dart';
import 'package:donaterio/user_donation_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main()
{
  runApp(MaterialApp(
    home: user_donate(),
  ),
  );
}

class user_donate extends StatefulWidget {
  @override
  _user_donateState createState() => _user_donateState();
}

class _user_donateState extends State<user_donate> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController codecontroller=TextEditingController();
  final donate=GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String Phone,smscode,verificationId;
  FirebaseAuth _auth=FirebaseAuth.instance;
  Future<void>verifyphone() async{
    final PhoneVerificationCompleted verified=(AuthCredential credential) async
    {
      AuthResult result=await _auth.signInWithCredential(credential);
      FirebaseUser user=result.user;
      if(user!=null)
        {
          print('verified');
          Navigator.push(context, MaterialPageRoute(builder: (context)=>user_donation_form(user: user,)));
        }



    };
    final PhoneVerificationFailed verificationFailed=(AuthException authException){
      print('${authException.message}');

    };
    final PhoneCodeSent smsSend=(String verId,[int forceResend])
    {
      this.verificationId=verId;
     showDialog(
         context:context,
       barrierDismissible: false,
       builder: (context)
         {
           return AlertDialog(
             title: Text('Enter the OTP'),
             content: Column(
               mainAxisSize: MainAxisSize.min,
               children: <Widget>[
                TextField(
                  controller: codecontroller,
                ),
               ],
             ),
             actions: <Widget>[
               FlatButton(
                 child: Text('Confirm'),
                 color: Colors.white,
                 textColor: Colors.black,
                 onPressed: () async
                 {

                     smscode = codecontroller.text;
                     AuthCredential credential = PhoneAuthProvider
                         .getCredential(
                         verificationId: verId, smsCode: smscode);
                     AuthResult result = await _auth.signInWithCredential(
                         credential);
                     FirebaseUser user = result.user;

                     if (user != null) {
                       Navigator.push(context, MaterialPageRoute(builder: (
                           context) => user_donation_form(user: user,)));
                     }



                 },
               ),
             ],

           );
         }
     );

    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout=(String verId)
    {
      this.verificationId=verId;

    };
    await _auth.verifyPhoneNumber
      (
      phoneNumber:this.Phone,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verified,
      verificationFailed: verificationFailed,
      codeSent: smsSend,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Donate'),
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
        key: donate,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(5.0),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/small_icon.png'),
                    radius: 60,
                  ),
                ),
              ),
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
                  controller: mobileController,
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
                    labelText: 'Mobile No',
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
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: FlatButton(
                    textColor: Colors.white,
                    child: Text('Submit'),
                    onPressed: () {

                        this.Phone = mobileController.text;
                        if(Phone.isEmpty)
                          {
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('Enter valid MobileNo'),
                                  duration: Duration(seconds: 3),
                                ));
                          }
                        else
                          {
                            verifyphone();
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
