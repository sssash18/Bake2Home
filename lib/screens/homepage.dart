import 'dart:async';

import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/screens/NoInternet.dart';
import 'package:bake2home/screens/ProfileOrders.dart';
import 'package:bake2home/screens/ProfilePage.dart';
import 'package:bake2home/screens/mainPage.dart';
import 'package:bake2home/services/PushNotification.dart';
import 'package:bake2home/services/database.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/screens/Cart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _index = 0;

  void _incrementTab(index) {
    setState(() {
      print('tapped');
      _index = index;
    });
  }


  void initState() {
    super.initState();
    pushNotification.init();
    WidgetsBinding.instance.addObserver(this);
    
  }

  final List<Widget> _children = [
    MainPage(),
    ProfileOrder(),
    Cart(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamProvider<bool>.value(
            value: DatabaseService().status, child: _children[_index]),
        bottomNavigationBar: FloatingNavbar(
          onTap: (index) {
            _incrementTab(index);
          },
          currentIndex: _index,
          fontSize: 0.0,
          borderRadius: 40.0,
          itemBorderRadius: 80.0,
          backgroundColor: base,
          selectedBackgroundColor: white,
          unselectedItemColor: white,
          iconSize: 25.0,
          items: [
            FloatingNavbarItem(
              customWidget: Icon(Icons.link),
              icon: Icons.home,
              title: '',
            ),
            FloatingNavbarItem(
              icon: Icons.receipt,
              title: '',
            ),
            FloatingNavbarItem(icon: Icons.shopping_cart, title: ''),
            FloatingNavbarItem(icon: Icons.person, title: ''),
          ],
        ));
  }

  
}
