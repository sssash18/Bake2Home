import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/HistoryTile.dart';



class ProfileOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: base,
        ),
        title: Text(
          'History',
          style: TextStyle(
            color: text,
          )
        )
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index){
            return HistoryTile();
          }
        )
      ),
    );
  }
}