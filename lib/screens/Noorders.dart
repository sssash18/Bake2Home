import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class NoOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
        child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:[ Lottie.asset(
                'assets/anims/noorders.json',
                height: MediaQuery.of(context).size.height/1.4,
                width: MediaQuery.of(context).size.width/1.4,
                //fit: BoxFit.fill

              ),
          Text("Not Accepting Orders \nWe will be back online soon",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold))
        ]
        
        ),
      ),
    );
  }
  }
