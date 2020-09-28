import 'package:bake2home/constants.dart';
import 'package:bake2home/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  final loginKey = GlobalKey<ScaffoldState>();

  String number;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: loginKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffeaafc8), Color(0xff654ea3)]),
        ),
        child: Container(
          child: Center(
            child: Material(
              elevation: 2.5,
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                width: width * 0.9,
                height: height * 0.4,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Sign In",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        TextFormField(
                          cursorColor: base,
                          decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              hintText: "Enter your mobile number"),
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          onChanged: (val) {
                            number = '+91' + val;
                          },
                          validator: (val) {
                            return val.length != 10
                                ? 'Invalid mobile number'
                                : null;
                          },
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 20),
                        FlatButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            color: base,
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                ProgressDialog pr = ProgressDialog(context,
                                    type: ProgressDialogType.Normal,
                                    isDismissible: true,
                                    showLogs: true);
                                pr.style(
                                    message: 'Signing in...',
                                    borderRadius: 10.0,
                                    backgroundColor: Colors.white,
                                    progressWidget: Center(
                                        child: CircularProgressIndicator()),
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
                                await AuthService()
                                    .verifyPhone(number, context, pr, loginKey);
                              }
                            },
                            icon: Icon(
                              Icons.done,
                              color: white,
                            ),
                            label: Text(
                              'Verify',
                              style: TextStyle(color: white),
                            ))
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
