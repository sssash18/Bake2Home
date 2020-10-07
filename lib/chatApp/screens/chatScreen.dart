import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bake2home/chatApp/firebaseServices/usermodel.dart';
import 'package:bake2home/chatApp/loadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bake2home/chatApp/firebaseServices/authservice.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  int mystate = 1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        {
          print('resumed');
          setState(() {
            mystate = 1;
          });
          break;
        }
      case AppLifecycleState.inactive:
        {
          print('inactive');
          setState(() {
            mystate = 0;
          });
          break;
        }
      case AppLifecycleState.paused:
        {
          print('paused');
          setState(() {
            mystate = 0;
          });
          break;
        }
      case AppLifecycleState.detached:
        {
          print('detached');
          setState(() {
            mystate = 0;
          });
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('state is $mystate');
    final user = Provider.of<ChatUser>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Users List"),
          leading: IconButton(
            icon: Icon(Icons.keyboard_backspace),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                AuthenticationService().signOut();
              },
            )
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('myUsers').snapshots(),
            builder: (context, ss) {
              return ss.hasData
                  ? (ListView.builder(
                      itemCount: ss.data.documents.length,
                      itemBuilder: (context, i) {
                        return ss.data.documents[i]['uid'] != user.uid
                            ? ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  child: Icon(Icons.person),
                                ),
                                title: Text(ss.data.documents[i]['email']),
                                subtitle: Text("last msg"),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 400),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          return SlideTransition(
                                              position: Tween<Offset>(
                                                      begin: const Offset(
                                                          1.0, 0.0),
                                                      end: Offset.zero)
                                                  .animate(animation),
                                              child: SlideTransition(
                                                position: Tween<Offset>(
                                                        begin: Offset.zero,
                                                        end: const Offset(
                                                            1.0, 0.0))
                                                    .animate(
                                                        secondaryAnimation),
                                                child: child,
                                              ));
                                        },
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) {
                                          // return ChatWithFriend(
                                          //     myid: user.uid,
                                          //     fid: ss.data.documents[i]['uid'],
                                          //     email: ss.data.documents[i]
                                          //         ['email'],mystate:mystate);
                                        },
                                      ));
                                },
                              )
                            : Container();
                      },
                    ))
                  : Temp(
                      size: 40,
                    );
            }));
  }
}
