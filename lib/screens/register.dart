import 'package:bake2home/functions/user.dart';
import 'package:bake2home/screens/homepage.dart';
import 'package:bake2home/screens/registerAddress.dart';
import 'package:bake2home/services/database.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Register extends StatefulWidget {
  final String uid, contact;
  Register({this.uid, this.contact});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name;

  String add;

  final formKey2 = GlobalKey<FormState>();

  final registerScaffold = GlobalKey<ScaffoldState>();
  TextEditingController addController;
  @override
  void initState() {
    addController = new TextEditingController();
    currentUser =
        new MyUser(addresses: {}, contact: '', name: '', token: '', uid: '');
    print(currentUser.addresses);
    super.initState();
  }

  divider() {
    return SizedBox(
      height: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    // currentUser =
    //     new MyUser(addresses: {}, contact: '', name: '', token: '', uid: '');
    print(currentUser.addresses);
    return Scaffold(
      
      key: registerScaffold,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffeaafc8), Color(0xff654ea3)]),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Form(
          key: formKey2,
          child: ListView(children: [
            Text(
              "Let us know you!",
              textAlign: TextAlign.center,
              style: TextStyle(color: white, fontWeight: FontWeight.bold),
            ),
            divider(),
            TextFormField(
                cursorColor: base,
                validator: (val) {
                  if (val.isEmpty) {
                    return "Name cannot be empty";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: "Your Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                }),
            divider(),
            TextFormField(
              cursorColor: base,
              decoration: InputDecoration(
                hintText: "Your Address",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0)),
              ),
              controller: addController,
              validator: (val) {
                if (val.isEmpty) {
                  return "Address cannot be empty";
                } else {
                  return null;
                }
              },
              onTap: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterAddress()));
                print('here gone to end');
                if (currentUser.addresses.isNotEmpty) {
                  setState(() {
                    List<dynamic> temp = currentUser.addresses.keys.toList();
                    var first = temp.first;
                    add = currentUser.addresses[first]['address'];
                    addController.text = add;
                    print('-------------------$add');
                  });
                }
              },
            ),
            divider(),
            Center(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                color: base,
                child: Text(
                  "Done",
                  style: TextStyle(
                      color: white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  AlertDialog ad = AlertDialog(
                    title: Text("Terms and Conditions",style:TextStyle(fontWeight: FontWeight.bold)),
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          gen,
                          Text(tnc,style:TextStyle(fontSize: 10)),
                          cancel,
                          Text(can,style:TextStyle(fontSize: 10)),
                        ],
                      )
                    ),
                    actions: [
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(border)
                        ),
                      onPressed: () async{
                        Navigator.pop(context);
                        if (formKey2.currentState.validate()) {
                    ProgressDialog pr = ProgressDialog(context,
                        type: ProgressDialogType.Normal,
                        isDismissible: true,
                        showLogs: true);
                    pr.style(
                        message: 'Updating Details...',
                        borderRadius: 10.0,
                        backgroundColor: Colors.white,
                        progressWidget:
                            Center(child: CircularProgressIndicator()),
                        elevation: 10.0,
                        insetAnimCurve: Curves.easeInOut,
                        progress: 0.0,
                        maxProgress: 100.0,
                        progressTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400),
                        messageTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600));
                    await pr.show();
                    bool rs = await DatabaseService().createUser(name,
                        widget.uid, widget.contact, currentUser.addresses);
                    await pr.hide();
                    if (rs) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()));
                    } else {
                      showSnackBar(registerScaffold, "Error Encountered");
                    }
                  }
                      },
                      color: base,
                      child: Text("I agree", style: TextStyle(color: white)),
                    )
                    ],
                  );
                  showDialog(context: context,builder: (context){
                    return ad;
                  });
                  
                },
              ),
            ),
            divider(),
          ]),
        ),
      ),
    );
  }
}
