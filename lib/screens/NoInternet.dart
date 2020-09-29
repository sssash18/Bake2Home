import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
        child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[ Center(
                child: Lottie.asset(
                'assets/anims/nointernet.json',
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width/2,
                //fit: BoxFit.fill

              ),
          ),
          Text("Network Error",style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold))
        ]
        
        ),
      ),
    );
  }
}