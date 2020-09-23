import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/VendorList.dart';
import 'package:flutter/material.dart';



class VendorListPage extends StatefulWidget {
  String title;
  bool rated;
  VendorListPage({this.title,this.rated});

  @override
  _VendorListPageState createState() => _VendorListPageState();
}

class _VendorListPageState extends State<VendorListPage> {
  
  

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
          widget.title,
          style: TextStyle(
            color: text,
          )
        )
      ),
      body: VendorList(category: widget.title.toLowerCase(),rated: widget.rated,),
      );
  }
}