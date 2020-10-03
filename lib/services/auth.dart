import 'package:bake2home/constants.dart';
import 'package:bake2home/functions/user.dart';
import 'package:bake2home/screens/homepage.dart';
import 'package:bake2home/screens/register.dart';
import 'package:bake2home/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:bake2home/functions/user.dart' as LocalUser;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sms_autofill/sms_autofill.dart';

class AuthService {
  UserCredential _user;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signIn(String verificationId, String otp, BuildContext context,
      ProgressDialog pr, GlobalKey<ScaffoldState> loginKey) async {
    print(
        '_______________________________________________________))) $verificationId');
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp);
    await _auth.signInWithCredential(credential).then((val) {
      _user = val;
    }).catchError((e) async {
      print('-------------------------------->');
      print(e);
      Navigator.pop(context);
      await pr.hide();
      showSnackBar(loginKey, 'Invalid Otp');
    });
    LocalUser.MyUser user;
    if (_user != null) {
      user = LocalUser.MyUser(
        name: '',
        contact: '',
        uid: _user.user.uid,
      );
    } else {
      user = null;
    }
    currentUser = user;
    currentUserID = currentUser.uid;
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .get()
        .catchError((e) {
      print('********************************* ${e.toString()}');
    });
    if (!ds.exists) {
      print('------------------null');
      await pr.hide();
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              Register(uid: _user.user.uid, contact: _user.user.phoneNumber)));
    } else {
      print('------------------------------------not nill');
      bool rs = await DatabaseService().updateToken(currentUserID);
      await getUser(currentUserID);
      await pr.hide();
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    }
  }

  Future<bool> getUser(String userId) async {
    print('------------->$userId');
    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .get()
        .catchError((e) {
      print(e.toString());
    });
    currentUserID = userId;
    currentUser = MyUser(
        uid: userId,
        name: user.data()['name'],
        addresses: user.data()['addresses'] == null
            ? {}
            : Map.from(user.data()['addresses']),
        contact: user.data()['contact'],
        token: user.data()['token']);
    await getCartDetails(userId);

    return true;
  }

  Future<void> getCartDetails(String uid) async {
    Stream<DocumentSnapshot> ss =
        FirebaseFirestore.instance.collection('Users').doc(uid).snapshots();
    ss.listen((event) {
      if (event.exists) {
        print('startting cartMap ${event.data()['cart']}');
        Map<String, dynamic> someMap = Map();
        if (event.data()['cart'] != null) {
          someMap = Map<String, dynamic>.from(event.data()['cart']);
        }
        // setState(() {
        print('fetched shopId is $currentShopId');
        if (someMap.isNotEmpty) {
          cartMap = Map<String, dynamic>.from(someMap);
        }
        cartLengthNotifier.value = cartMap.length;
        currentShopId = someMap['shopId'].toString();
        print('cartMap is $cartMap');
        // });
      }
    });
  }

  Future<void> verifyPhone(String contact, BuildContext context,
      ProgressDialog pr, GlobalKey<ScaffoldState> loginKey) async {
    String otp;
    await _auth.verifyPhoneNumber(
        timeout: Duration(seconds: 0),
        phoneNumber: contact,
        verificationCompleted: (crd) async {
          await signIn(crd.verificationId, crd.smsCode, context, pr, loginKey);
        },
        verificationFailed: (e) async {
          print("EEEEE" + e.toString());
          await pr.hide();
          loginKey.currentState.showSnackBar(SnackBar(
              duration: Duration(seconds: 20), content: Text("${e.message}")));
        },
        codeSent: (verificationId, resendToken) async {
          // String sign = await SmsAutoFill().getAppSignature;
          // await SmsAutoFill().listenForCode;
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
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: PinFieldAutoFill(
                              currentCode: otp,
                              onCodeSubmitted: (val) {
                                otp = val;
                              }, //code submitted callback
                              onCodeChanged: (val) {
                                otp = val;
                              }, //code changed callback
                              codeLength: 6 //code length, default 6
                              ),
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
                                //SmsAutoFill().unregisterListener();
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
                                await signIn(
                                    verificationId, otp, context, pr, loginKey);
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
        codeAutoRetrievalTimeout: (id) {});
  }
}
