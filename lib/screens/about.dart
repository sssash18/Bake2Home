import 'package:flutter/material.dart';

import '../constants.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About", style: TextStyle(fontSize: 18,color:base)),backgroundColor: white,iconTheme: IconThemeData(color: base),),
      body: Container(
        child: Column(
          children: [
            ListTile(
              title: Text("Licenses"),trailing: Icon(Icons.arrow_forward_ios),
              onTap: (){
                showLicensePage(
                  context: context,
                  applicationName: "BakeMyCake",
                  applicationVersion: "v1.1",
                  applicationIcon: Image.asset("assets/images/logo.png",height: 150,),
                  
                );
              },
            )
          ],

        )
      ),
    );
  }
}