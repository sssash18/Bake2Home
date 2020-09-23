import 'package:bake2home/screens/homepage.dart';
import 'package:bake2home/services/database.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Register extends StatelessWidget {
  final String uid, contact;
  Register({this.uid, this.contact});
  String name;
  String add;

  final formKey2 = GlobalKey<FormState>();

  final registerScaffold = GlobalKey<ScaffoldState>();
  divider() {
    return SizedBox(
      height: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Details"),
      ),
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
              style: TextStyle(color: black, fontWeight: FontWeight.bold),
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
                  name = val;
                }),
            divider(),
            TextFormField(
                cursorColor: base,
                decoration: InputDecoration(
                  hintText: "Your Address",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
                onChanged: (val) {
                  add = val;
                }),
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
                    bool rs =
                        await DatabaseService().createUser(name, uid, contact);
                    await pr.hide();
                    if (rs) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => HomePage()));
                    } else {
                      showSnackBar(registerScaffold, "Error Encountered");
                    }
                  }
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
