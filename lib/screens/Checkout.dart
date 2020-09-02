import 'package:bake2home/screens/OrderPending.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/screens/Payment.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
   bool _canContinue= true;
    int _index = 0;
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
          body: Container(
              decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffeaafc8), Color(0xff654ea3)]),
              borderRadius: BorderRadius.circular(border),
            ),
              child: Stepper(
              currentStep: _index,
              // controlsBuilder: (BuildContext context,{VoidCallback onStepContinue,VoidCallback onStepCancel}){
              //   return Container();
              // },
              onStepContinue: (){
                setState(() {
                  _index++;
                });
              },
              onStepTapped: (val){
                setState(() {
                  _index = val;
                });
              },
              steps: [
                Step(
                  title: Text("Requesting Vendor"),
                  subtitle: Text('Requesting vendor with the required items'),
                  content: OrderPending(),
                  isActive: true,
                  state: StepState.editing
                ),
                Step(
                  title: Text("Vendor Response"),
                  subtitle: Text('Vendor Response for the requirements'),
                  content: Text("Phone Aaya"),
                  isActive: false,
                ),
                Step(
                  title: Text("Payment"),
                  state: StepState.values.elementAt(0),
                  subtitle: Text('Choose your payment mode'),
                  content:  FlatButton(child: Text("Pay"),
                  
                  onPressed: (){
                     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Payment()));
                  },
                  ),
                  isActive: false,
                ),
              ],
            ),
          ),
    );
  }
}