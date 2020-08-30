import 'package:bake2home/screens/ProfileOrders.dart';
import 'package:bake2home/screens/ProfilePage.dart';
import 'package:bake2home/screens/mainPage.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/screens/Cart.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  void _incrementTab(index) {
    setState(() {
      print('tapped');
      _index = index;
    });
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
        body: _children[_index],
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
