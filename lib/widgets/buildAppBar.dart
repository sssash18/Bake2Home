import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';

class buildAppBar extends StatefulWidget {
  @override
  _buildAppBarState createState() => _buildAppBarState();
}

class _buildAppBarState extends State<buildAppBar> {

  Icon icon  = Icon(Icons.search);
  Widget appBarTitle = Text('');

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: white,
        title: appBarTitle,
        elevation: 0.0,
        actions: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: IconButton(
              icon: icon,
              onPressed: (){
                setState((){
                  this.icon = Icon(Icons.close);
                  this.appBarTitle = new TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.close),
                        hintText: "Search....",
                      ),
                  );
                });
              },
            ),
          )
        ],
      );
  }
}