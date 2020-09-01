
import 'package:bake2home/screens/Payment.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bake2home/constants.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';





class OrderPending extends StatefulWidget {
  @override
  _OrderPendingState createState() => _OrderPendingState();
}

class _OrderPendingState extends State<OrderPending> {

  

  @override
  Widget build(BuildContext context) {
    
    if(!activeTimer){
      timer = StopWatchTimer(
        onChangeRawSecond: (val){
          if(val == 90){
            timer.onExecute.add(StopWatchExecute.stop);
            activeTimer = false;
          }
          print(val);
        }
      );
      timer.onExecute.add(StopWatchExecute.start);
      activeTimer = true;
    }

    
    return Scaffold(
    body: Container(
      child : Column(
              children: [Center(child: 
          Text(timer.rawTime.value.toString())
        ),
        FlatButton(child: Text("Pay"),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Payment()));
          },
        ),
        ]
      )
    ),
      );
  }
}