import 'package:bake2home/screens/ProfilePage.dart';
import 'package:bake2home/services/database.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  bool _editMode = false;
  Widget _icon = Icon(Icons.edit);
  String contactHint = "";
  final  _formKey = GlobalKey<FormState>();
  
  Widget _returnWidget(bool edit, String _initialText, String _label){
    if(!edit){
      return AnimatedContainer(
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
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
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
      child: TextFormField(
        validator: (val) => val.isEmpty ? 'Please enter a valid  ${_label.toLowerCase()}' : null,
        initialValue: _initialText,
        decoration: InputDecoration(
          labelText: _label,
          border: OutlineInputBorder()
        ),
        onChanged: (val){
          if(_label == "Name"){
            currentUser.name = val;
          }
          if(_label == "Address"){
            currentUser.address = val;
          }
        },
      ),
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: Text("Profile",style: TextStyle(color: base)),
    backgroundColor: white,
    iconTheme: IconThemeData(color: base),
    elevation: 0.0,
    actions: <Widget>[
      IconButton(icon: _icon, onPressed:()async {
        setState(() {
          _editMode = !_editMode;
          if(_editMode){
            _icon = Icon(Icons.done);
            contactHint = "Contact cannot be changed";
          }else{
            _icon = Icon(Icons.edit);
            contactHint = "";
           
          }
        });
        if(!_editMode && _formKey.currentState.validate()){
          await DatabaseService(uid : currentUserID).updateUserDetails(currentUser.name, currentUser.address);
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
      height: MediaQuery.of(context).size.height/3,
      width: MediaQuery.of(context).size.width,
      child: CircleAvatar(
          backgroundColor: base,
          radius: 60.0,
          child: Text(
            ProfilePage().createAvatarText(),
            style: TextStyle(
              color: white,
              fontSize: 40.0,
            )
          ),
      )
      ),
      Form(
        key: _formKey,
        child: Column(
          children :<Widget>[
            AnimatedContainer(
              child: _returnWidget(_editMode,currentUser.name,"Name"),
              duration: Duration(microseconds: 100),
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/20),
            ),
            AnimatedContainer(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/20),
              duration: Duration(microseconds: 2000),
              child: AnimatedContainer(
              duration: Duration(microseconds: 2000),
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
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
            AnimatedContainer(
              child: _returnWidget(_editMode,currentUser.address,"Address"),
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/20),
              duration: Duration(microseconds: 100),
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