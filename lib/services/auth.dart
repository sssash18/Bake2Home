import 'package:bake2home/constants.dart';
import 'package:bake2home/functions/user.dart';
import 'package:bake2home/screens/homepage.dart';
import 'package:bake2home/screens/register.dart';
import 'package:bake2home/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:bake2home/functions/user.dart' as LocalUser;
import 'package:progress_dialog/progress_dialog.dart';

class AuthService {
  UserCredential _user;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signIn(String verificationId, String otp, BuildContext context,
      ProgressDialog pr) async {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    _user = await _auth.signInWithCredential(credential).catchError((e) {
      print(e);
    });
    LocalUser.MyUser user = LocalUser.MyUser(
      name: '',
      contact: '',
      uid: _user.user.uid,
    );
    currentUser = user;
    currentUserID = currentUser.uid;
    if (_user.additionalUserInfo.isNewUser) {
      await pr.hide();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Register(
                  uid: _user.user.uid, contact: _user.user.phoneNumber)));
    } else {
      await pr.hide();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }
    DatabaseService().updateToken(await firebaseMessaging.getToken());
  }

  Future<void> verifyPhone(
      String contact, BuildContext context, ProgressDialog pr) {
    String otp;
    _auth.verifyPhoneNumber(
        phoneNumber: contact,
        verificationCompleted: (crd) {
          signIn(crd.verificationId, crd.smsCode, context, pr);
        },
        verificationFailed: (e) {
          print("EEEEE" + e.toString());
        },
        codeSent: (verificationId, resendToken) async {
          print("Sent COde");
          await pr.hide();
          showModalBottomSheet(
              context: context,
              // isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              // isScrollControlled: true,
              isDismissible: false,
              builder: (context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Submit Otp",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: black, fontWeight: FontWeight.bold),
                        ),
                        OTPTextField(
                          keyboardType: TextInputType.number,
                          length: 6,
                          width: MediaQuery.of(context).size.width / 1.3,
                          onCompleted: (val) {
                            otp = val;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              color: base,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: white, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                ProgressDialog pr = ProgressDialog(context,
                                    type: ProgressDialogType.Normal,
                                    isDismissible: true,
                                    showLogs: true);
                                pr.style(
                                    message: 'Submitting otp...',
                                    borderRadius: 10.0,
                                    backgroundColor: Colors.white,
                                    progressWidget: Center(
                                        child: CircularProgressIndicator()),
                                    elevation: 10.0,
                                    insetAnimCurve: Curves.easeInOut,
                                    progress: 0.0,
                                    maxProgress: 100.0,
                                    progressTextStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w400),
                                    messageTextStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.w600));
                                await pr.show();
                                await signIn(verificationId, otp, context, pr);
                              },
                            ),
                            FlatButton(
                              color: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: white, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        )
                      ]),
                );
              });
        },
        timeout: Duration(seconds: 90),
        codeAutoRetrievalTimeout: (id) {});
  }
}
