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

  Future<UpiResponse> initiateTransaction(){
    return _upiIndia.startTransaction(
      app: apps[0].app,
      receiverUpiId: 'pmcares@sbi',
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
              children: [
                Center(
                child: FlatButton(
            child: Text("Pay"),
            onPressed: () async{
              _response = await initiateTransaction();
              if(_response.error!=null){
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
              }
              }else{
                setState(() {
                  _text ='${_response.transactionId} ${_response.status}';
                });
              }        
            },
          ),
        ),
        Text(_text),
        ]
      ),
    );
  }
}