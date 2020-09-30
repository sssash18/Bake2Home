import 'package:bake2home/chatApp/firebaseServices/usermodel.dart';
import 'package:bake2home/chatApp/screens/chatScreen.dart';
import 'package:bake2home/chatApp/signupService/authScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ChatUser>(context);
    print('USER ENTERED $user');
    if (user == null)
      return AuthScreen();
    else {
      //RealtimeDatabase().addUsers(user.uid, 'online', DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString());
      return ChatScreen();
    }
  }
}
