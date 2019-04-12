import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Successfully Signed In', 
              style: TextStyle(color: Colors.red, 
              fontWeight: FontWeight.bold, fontSize: 40.0),),
              new OutlineButton(
                  borderSide: BorderSide(
                      color: Colors.red, style: BorderStyle.solid, width: 3.0),
                  child: Text('Logout'),
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((action) {
                      Navigator.of(context).pushReplacementNamed('/landingpage');
                    }).catchError((e) {
                      print(e);
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}