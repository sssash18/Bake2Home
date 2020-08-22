import 'package:flutter/material.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/functions/user.dart';

Color base = Color(0xff654ea3);
Color white = Colors.white;
Color text = Color(0xff654ea3);
Color button = Colors.pink[800];
Color pastry = Colors.grey[200];
Color grad1 = Color(0xffeaafc8);
Color grad2 = Color(0xff654ea3);
Color black = Colors.black;
double head = 20.0;
double head2 = 30.0;
double textSize = 18.0;
double sideButton = 12.0;
double border = 20.0;
Map<String, Shop> shopMap = new Map<String, Shop>();
Map<String, Shop> topPickMap = new Map<String, Shop>();
String currentUserID = "94ON8vhE5kxa7SfOyBWJ";
User currentUser = new User();

Map<String, dynamic> cartMap = Map<String, dynamic>();
ValueNotifier<int> cartLengthNotifier = ValueNotifier<int>(0);
String currentShopId = 'null';
