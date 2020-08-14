import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/VendorList.dart';
import 'package:flutter/material.dart';


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