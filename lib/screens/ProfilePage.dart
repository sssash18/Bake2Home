import 'package:bake2home/screens/ProfileOrders.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/screens/UserDetails.dart';

class ProfilePage extends StatefulWidget {
  String createAvatarText(){
    List<String> nameList = currentUser.name.split(" ");
    String result = "";
    if(nameList.contains('')){
     result += nameList[0][0].toUpperCase();
     return result;
    }
    nameList.forEach((element) {
      result += element[0].toUpperCase();
    });
    return result;

  }
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: base,
        ),
        
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: text,
          )
        ),
        centerTitle: true,
        backgroundColor: white,
      ),
      body: SingleChildScrollView(
              child: Column(
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
                widget.createAvatarText(),
                style: TextStyle(
                  color: white,
                  fontSize: 40.0,
                )
              ),
            )
          ),
          Text(
            '${currentUser.name}',
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
                  ' ${currentUser.addresses['Ad1']['address']}',
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
          
              Container(
              
              margin: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
              child:ListView(
                shrinkWrap: true,
                physics: ScrollPhysics(
                  parent: NeverScrollableScrollPhysics(),
                ),
                children: <Widget>[
                  ListTile(
                    leading:Icon(
                      Icons.person,
                      color: base,
                      size: 30.0,
                    ),
                    title: Text(
                      "Profile",
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UserDetails())).then((value) => setState((){}));
                    },
                  ),
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
          
        ]
        ),
      )
    );
  }
}