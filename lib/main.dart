import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_phoneauth/homepage.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(),
      routes: <String, WidgetBuilder> {
        '/homepage': (BuildContext context) => HomePage(),
        '/landingpage': (BuildContext context) => MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  // TextEditingController
  String phoneNo;
  String smsCode;
  String verificationId;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone() async {
    
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value){
        print('Signed In');
      });
    };

    final PhoneVerificationCompleted verifiredSuccess = (FirebaseUser user) {
      print('Verified');
    };

    final PhoneVerificationFailed verfiFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: this.phoneNo,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verifiredSuccess,
      verificationFailed: verfiFailed,
    );
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('Enter sms Code'),
          content: TextField(
            onChanged: (value){
              this.smsCode = value;
            },
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            new FlatButton(
              child: Text('Done'),
              onPressed: () {
                FirebaseAuth.instance.currentUser().then((user) {
                  if(user != null) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/homepage');
                  }
                  else {
                    Navigator.of(context).pop();
                    signIn();
                  }
                });
              },
            )
          ],
        );
      }
    );
  }

  void signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential).then((user) {
      Navigator.of(context).pushReplacementNamed('/homepage');
    })
    .catchError((e){
      print(e);
    });
  }

  // InitState Section ....

  // Widget build section ....
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('PhoneAuth'),
      ),
      body: new Center(
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Enter Phone number'),
                onChanged: (value) {
                  this.phoneNo = value;
                },
              ),
              SizedBox(height: 10.0,),
              RaisedButton(
                onPressed: verifyPhone,
                child: Text('Verify'),
                textColor: Colors.white,
                elevation: 7.0,
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}