import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/VendorList.dart';
import 'package:flutter/material.dart';


class VendorListPage extends StatelessWidget {
  String title;
  bool rated;
  VendorListPage({this.title,this.rated});
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
          title,
          style: TextStyle(
            color: text,
          )
        )
      ),
      body: VendorList(category: title.toLowerCase(),rated: rated,),
      );
  }
}