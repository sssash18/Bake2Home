import 'package:upi_india/upi_india.dart';
import 'package:flutter/material.dart';


class Payment extends StatefulWidget { 
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp> apps;
  UpiResponse _response;
  @override
  void initState() {
    super.initState();
    _upiIndia.getAllUpiApps().then((value){
      setState((){
        apps = value;
      });
    });
    
  }

  Future<UpiResponse> initiateTransaction() {
    return _upiIndia.startTransaction(
      app: apps[0].app,
      receiverUpiId: 'bakemycake@ybl',
      receiverName: "BakeMyCake",
      transactionRefId: "1233434",
      transactionNote: '#bmc2323111',
      amount: 1.0,
    );
  }
  @override
  Widget build(BuildContext context) {
    String _text = "Pay";
    
    return Scaffold(
      body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                child: FlatButton(
            child: Text("Pay"),
            onPressed: () async{
              _response = await initiateTransaction();
              if(_response.error!=null){
                print(_response.error.toString());
                switch (_response.error) {
                case UpiError.APP_NOT_INSTALLED:
                  setState(() {
                    _text = ("Requested app not installed on device");
                  });
                break;
                case UpiError.INVALID_PARAMETERS:
                  setState(() {
                    _text =  "Requested app cannot handle the transaction";  
                  });
                break;
                case UpiError.NULL_RESPONSE:
                  setState(() {
                      _text = "requested app didn't returned any response";
                  });
                break;
                case UpiError.USER_CANCELLED:
                  setState(() {
                    _text = "You cancelled the transaction";
                  });
                break;
                default: 
                  setState((){
                    _text = "Error";
                  });
                
              }
              }else{
                setState(() {
                  _text ='${_response.transactionId} ${_response.status}';
                });
              }
              print("TEXT ${_text}");        
            },
          ),
        ),
        Text(_text),
        ]
      ),
    );
  }
}