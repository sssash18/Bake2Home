import 'package:bake2home/screens/Address.dart';
import 'package:bake2home/screens/ProfilePage.dart';
import 'package:bake2home/services/database.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  bool _editMode = false;
  Widget _icon = Icon(Icons.edit);
  String contactHint = "";
  final _formKey = GlobalKey<FormState>();

  Widget _returnWidget(bool edit, String _initialText, String _label) {
    if (!edit) {
      return AnimatedContainer(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20),
        duration: Duration(microseconds: 2000),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: _label,
          ),
          readOnly: true,
          initialValue: _initialText,
        ),
      );
    }
    return AnimatedContainer(
      duration: Duration(microseconds: 2000),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 20),
      child: TextFormField(
        validator: (val) => val.isEmpty
            ? 'Please enter a valid  ${_label.toLowerCase()}'
            : null,
        initialValue: _initialText,
        decoration:
            InputDecoration(labelText: _label, border: OutlineInputBorder()),
        onChanged: (val) {
          if (_label == "Name") {
            currentUser.name = val;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: base)),
        backgroundColor: white,
        iconTheme: IconThemeData(color: base),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: _icon,
              onPressed: () async {
                setState(() {
                  _editMode = !_editMode;
                  if (_editMode) {
                    _icon = Icon(Icons.done);
                    contactHint = "Contact cannot be changed";
                  } else {
                    _icon = Icon(Icons.edit);
                    contactHint = "";
                  }
                });
                if (!_editMode && _formKey.currentState.validate()) {
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
                  await DatabaseService(uid: currentUserID)
                      .updateUserDetails(currentUser.name);
                  await pr.hide();
                  Navigator.pop(context);
                }
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                color: white,
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                child: CircleAvatar(
                  backgroundColor: base,
                  radius: 60.0,
                  child: Text(createAvatarText(),
                      style: TextStyle(
                        color: white,
                        fontSize: 40.0,
                      )),
                )),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  AnimatedContainer(
                    child: _returnWidget(_editMode, currentUser.name, "Name"),
                    duration: Duration(microseconds: 100),
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 20),
                  ),
                  AnimatedContainer(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 20),
                    duration: Duration(microseconds: 2000),
                    child: AnimatedContainer(
                      duration: Duration(microseconds: 2000),
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          helperText: contactHint,
                          labelText: "Contact",
                        ),
                        readOnly: true,
                        initialValue: currentUser.contact,
                      ),
                    ),
                  ),
                  currentUser.addresses.isEmpty
                      ? Text("No addresses found")
                      : AnimatedContainer(
                          child: _returnWidget(
                              _editMode,
                              currentUser.addresses['Ad1']['address'],
                              "Address"),
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 20),
                          duration: Duration(microseconds: 100),
                        ),
                  FlatButton(
                    color: base,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Text('Manage Addresses',
                        style: TextStyle(
                            color: white, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Address()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
