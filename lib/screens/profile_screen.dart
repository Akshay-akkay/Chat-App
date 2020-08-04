import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
      ),
      body: FlatButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pop();
          },
          child: Row(
            children: <Widget>[
              Icon(Icons.power),
              SizedBox(width: 15),
              Text('Log Out'),
            ],
          )),
    );
  }
}
