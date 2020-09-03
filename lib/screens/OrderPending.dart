
import 'package:bake2home/screens/Payment.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
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
    
    // if(!activeTimer){
    //   timer = StopWatchTimer(
    //     onChangeRawSecond: (val){
    //       if(val == 90){
    //         timer.onExecute.add(StopWatchExecute.stop);
    //         activeTimer = false;
    //       }
    //       print(val);
    //     }
    //   );
    //   timer.onExecute.add(StopWatchExecute.start);
    //   activeTimer = true;
    // }

    
    return 
     Container(
      height: 200,
      width: 400,
      alignment: Alignment.center,
      child : CircularCountDownTimer(
        width: MediaQuery.of(context).size.width/2, 
        height: 200, 
        duration: 9, 
        fillColor: white, 
        color: base,
        isTimerTextShown: true,
        isReverse: true,
        onComplete: (){
          controller.add(true);
        },
      )
        
      );
    
    
  }
}