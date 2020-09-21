import 'package:bake2home/constants.dart';
import 'package:bake2home/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String number;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextFormField(
            decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter your mobile number"),
            maxLength: 10,
            keyboardType: TextInputType.phone,
            onChanged: (val){
              number = '+91' + val;
            },
            validator: (val){
              return val.length!=10 ? 'Invalid mobile number' : null;
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height/20),
          FlatButton.icon(
            onPressed: (){
              AuthService().verifyPhone(number,context);
            }, 
            icon: Icon(Icons.done), 
            label: Text('Verify')
          )
        ]
      ),
    );
  }
}