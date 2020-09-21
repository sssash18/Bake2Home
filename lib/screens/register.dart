import 'package:bake2home/screens/homepage.dart';
import 'package:bake2home/services/database.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';

class Register extends StatelessWidget {
  final String uid,contact;
  Register({this.uid,this.contact});
  @override
  Widget build(BuildContext context) {
    String name;
    return Scaffold(
      body: Column(
        children:[ 
          TextFormField(
            onChanged:(val){
              name = val;
            }
          ),
          FlatButton(
            child: Text("Done"),
            onPressed: (){
              DatabaseService().createUser(name, uid, contact);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
            },
          ),
        ]
      ),
    );
  }
}