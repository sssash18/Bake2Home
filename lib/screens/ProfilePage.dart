import 'package:bake2home/screens/ProfileOrders.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: base,
        ),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: null,
            icon: Icon(
              Icons.edit,
              color: base,
            ),
            label: Text(''))
        ],
        title: Text(
          'Profile',
          style: TextStyle(
            color: text,
          )
        ),
        centerTitle: true,
        backgroundColor: white,
      ),
      body: Column(
        children: <Widget>[
          Container(
          margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          alignment: Alignment.center,
          color: white,
          height: 180.0,
          width: 400,
          child: CircleAvatar(
            backgroundColor: base,
            radius: 60.0,
            child: Text(
              'SC',
              style: TextStyle(
                color: white,
                fontSize: 40.0,
              )
            ),
          )
        ),
        Text(
          'Suyash Choudhary',
          style: TextStyle(
            fontSize: head,
            fontWeight: FontWeight.bold
          )
        ),
        SizedBox(height: 10.0,),
        Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
              child: Text(
                ' Katju Nagar ',
                style: TextStyle(
                )
              ),
            ),
            Icon(
                Icons.location_on,
                size: 20.0,    
                color: text,
              )
          ]
        ),
        SizedBox(height:25.0),
        Expanded(
            child: Container(
            margin: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
            child:ListView(
              children: <Widget>[
                
                ListTile(
                  leading:Icon(
                    Icons.shopping_cart,
                    color: base,
                    size: 30.0,
                  ),
                  title: Text(
                    "Cart",
                  )
                ),
                ListTile(
                  leading:Icon(
                    Icons.history,
                    color: base,
                    size: 30.0,
                  ),
                  title: Text(
                    "History",
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(BuildContext context) =>  ProfileOrder()));
                  },
                ),
                ListTile(
                  leading:Icon(
                    Icons.settings,
                    color: base,
                    size: 30.0,
                  ),
                  title: Text(
                    "Settings",
                  )
                ),
                ListTile(
                  leading:Icon(
                    Icons.help_outline,
                    color: base,
                    size: 30.0,
                  ),
                  title: Text(
                    "Help and Support",
                  )
                ),
                ListTile(
                  leading:Icon(
                    Icons.exit_to_app,
                    color: base,
                    size: 30.0,
                  ),
                  title: Text(
                    "Sign Out",
                  )
                ),
              ],
            )
          ),
        )
      ]
      )
    );
  }
}