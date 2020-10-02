import 'dart:async';

import 'package:bake2home/screens/NoInternet.dart';
import 'package:bake2home/screens/ProfileOrders.dart';
import 'package:bake2home/screens/signIn.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/screens/UserDetails.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstAddress;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> subs ;
  bool internetStatus = true;
  @override
  Widget build(BuildContext context) {
    _connectivity.checkConnectivity().then((value){
      if(value == ConnectivityResult.none){
        internetStatus = false;
      }
    });
    subs = _connectivity.onConnectivityChanged.listen((ConnectivityResult event) { 
      setState(() {
        if(event == ConnectivityResult.none){
          internetStatus = false;
        }else{
          internetStatus = true;
        }
      });
    });
    
    if (currentUser.addresses.isEmpty) {
      firstAddress = 'No address found';
    } else {
      List<dynamic> list = currentUser.addresses.keys.toList();
      firstAddress = currentUser.addresses[list[0]]['address'];
    }
    print("UUUUUUUUU" + currentUser.uid);
    return internetStatus ? Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: base,
          ),
          title: Text('Dashboard',
              style: TextStyle(
                color: text,
              )),
          centerTitle: true,
          backgroundColor: white,
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                alignment: Alignment.center,
                color: white,
                height: 180.0,
                width: 400,
                child: CircleAvatar(
                  backgroundColor: base,
                  radius: 60.0,
                  child: Text(createAvatarText(),
                      style: TextStyle(
                        color: white,
                        fontSize: 40.0,
                      )),
                )),
            Text('${currentUser.name}',
                style: TextStyle(fontSize: head, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10.0,
            ),
            Stack(children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                child: Text('$firstAddress',
                    // ${currentUser.addresses['Ad1']['address']}
                    // ',
                    style: TextStyle()),
              ),
              Icon(
                Icons.location_on,
                size: 20.0,
                color: text,
              )
            ]),
            SizedBox(height: 25.0),
            Container(
                margin: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(
                    parent: NeverScrollableScrollPhysics(),
                  ),
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: base,
                        size: 30.0,
                      ),
                      title: Text(
                        "Profile",
                      ),
                      onTap: () async {
                        await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UserDetails()))
                            .then((value) => setState(() {}));
                      },
                    ),
                    ListTile(
                        leading: Icon(
                          Icons.shopping_cart,
                          color: base,
                          size: 30.0,
                        ),
                        title: Text(
                          "Terms and Conditions",
                        )),
                    ListTile(
                        leading: Icon(
                          Icons.settings,
                          color: base,
                          size: 30.0,
                        ),
                        title: Text(
                          "About",
                        )),
                    ListTile(
                        leading: Icon(
                          Icons.help_outline,
                          color: base,
                          size: 30.0,
                        ),
                        title: Text(
                          "Help and Support",
                        )),
                    ListTile(
                        leading: Icon(
                          Icons.exit_to_app,
                          color: base,
                          size: 30.0,
                        ),
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => SignIn()),
                              (route) => false);
                        },
                        title: Text(
                          "Sign Out",
                        )),
                  ],
                )),
          ]),
        )) : NoInternet();
  }
  @override
  void dispose(){
    super.dispose();
    subs.cancel();
  }
}
