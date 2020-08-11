import 'package:bake2home/constants.dart';
import 'package:bake2home/services/database.dart';
import 'package:bake2home/widgets/VendorList.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/widgets/VendorTile.dart';
import 'package:provider/provider.dart';
import 'package:bake2home/functions/shop.dart';

class VendorListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: base,
        ),
        title: Text(
          'Cakes',
          style: TextStyle(
            color: text,
          )
        )
      ),
      body: VendorList(),
      );
  }
}