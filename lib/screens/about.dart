import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    String title = "<a href=\"https://www.freepik.com/vectors/birthday\">Birthday vector created by freepik - www.freepik.com</a>";
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
            ),
            SizedBox(height:10),
            Container(
              child: Text("Credits/Attributions",style: TextStyle(fontSize: 18,color:base,fontWeight: FontWeight.bold)),
            ),
            SizedBox(height:10),
            Container(
              child: Text("freepik",style: TextStyle(fontSize: 15,color:base,fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: (){
                launch("https://www.freepik.com/vectors/birthday");
              },
              title: Text("Birthday vector created by freepik - www.freepik.com",style: TextStyle(color: Colors.blue),)
            ),
            Container(
              child: Text("LottieFiles",style: TextStyle(fontSize: 15,color:base,fontWeight: FontWeight.bold)),
            ),
            ListTile(
              
              title: Text("@Sandra Cabrera de Diego/LottieFiles",)
            ),
            ListTile(
              
              title: Text("@Rameez Mukadam/LottieFiles",)
            ),
            ListTile(
              
              title: Text("@Nick/LottieFiles",)
            ),
             ListTile(
              
              title: Text("@Akhilesh Singh/LottieFiles",)
            )
          ],

        )
      ),
    );
  }
}