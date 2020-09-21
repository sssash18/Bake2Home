import 'package:bake2home/constants.dart';
import 'package:bake2home/functions/user.dart';
import 'package:bake2home/screens/homepage.dart';
import 'package:bake2home/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:bake2home/functions/user.dart' as LocalUser;

class AuthService{

  UserCredential _user;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signIn(String verificationId, String otp,BuildContext context) async{
    AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
    _user = await _auth.signInWithCredential(credential);
    LocalUser.User user = LocalUser.User(
      name: '',
      contact: '',
      uid: _user.user.uid,
    ); 
    currentUser = user;
    currentUserID = currentUser.uid;
    if(_user.additionalUserInfo.isNewUser){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Register(uid : _user.user.uid,contact: _user.user.phoneNumber)));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }
    
  }
  

  Future<void> verifyPhone(String contact,BuildContext context){
    String otp;
    _auth.verifyPhoneNumber(
      phoneNumber: contact, 
      verificationCompleted: (crd){
        signIn(crd.verificationId, crd.smsCode,context);
      }, 
      verificationFailed: (e){print("EEEEE"  + e.toString());}, 
      codeSent: (verificationId,resendToken)async {
        print("Sent COde");
        showModalBottomSheet(
          context: context, 
          builder: (BuildContext context){
            return Column(
                children:[ OTPTextField(
                length: 6,
                width: MediaQuery.of(context).size.width/1.3,
                onCompleted: (val){otp = val;},
              ),
              FlatButton(child: Text('Submit'),onPressed: ()async {
                await signIn(verificationId, otp,context);
               
              },)
              ]
            );
          }
        );
        
      }, 
      timeout: Duration(seconds: 90),
      codeAutoRetrievalTimeout: (id){});
      
  }

  
}