import 'dart:async';

import 'package:bake2home/services/database.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Address extends StatefulWidget  {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  Map _addval = currentUser.addresses['Ad1'];
  bool _loading  = false;
  double _height = 0;
  Completer<GoogleMapController> _controller = Completer();
  Map _newaddress = Map();
  String  _addressNew = "";
  TextEditingController _textController = TextEditingController(text: "");
  
  Widget _returnButtonOrLoading(bool loading){
    if(loading){
      return CircularProgressIndicator();
    }
    return FlatButton.icon(
      onPressed: (){
        // setState(() {
        //   _loading = true;
        // });
        DatabaseService(uid: currentUserID).addAddress(_newaddress).then((value){
        //   setState(() {
        //   _height = 0;
        //   _loading = false;
        // });
        });
        
      },
      icon: Icon(Icons.done,color: white,),
      label: Text("Confirm",style: TextStyle(color: white)),
      color : base,
      shape: RoundedRectangleBorder(
      borderRadius : BorderRadius.circular(border)
      ),
    );
  }

  Widget _returnMap(double lat,double longi,String address){
    final CameraPosition _position = CameraPosition(
      target: LatLng(lat, longi),
      zoom: 16.4746
    );
    final marker  = Marker(
      markerId : MarkerId('12'),
      draggable: true,
      onDragEnd: (coord){
       
        if(coord!=null){
          Geolocator().placemarkFromCoordinates(lat, longi).then((value){
          setState(() {
            _addressNew = "${value[0].subThoroughfare} ${value[0].subLocality},${value[0].locality} - ${value[0].postalCode},${value[0].country}";
            _textController.text = _addressNew;
          });
          }
         );
        }
      },
      position :LatLng(lat, longi),
      infoWindow: InfoWindow(
        title: "Address",
        snippet : address,
      )

    );

    
    Set<Marker> _markers = Set();
    _markers.add(marker);
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _position,
      onMapCreated: (GoogleMapController controller){
        _controller.complete(controller);
      },
      markers: _markers,
    );
  }

  void _travelMap(double lat, double longi){
    final Future<GoogleMapController> cont =_controller.future;
    cont.then((value){
      value.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, longi),zoom:16.4746 )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: base,
        ),
        title: Text(
          "Manage Addresses",
          style : TextStyle(color:  base)
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
              child: Column(
          children: [
            Container(
              height : MediaQuery.of(context).size.height/2.2,
              width : MediaQuery.of(context).size.width,
              child: _returnMap(_addval['lat'],_addval['long'],_addval['address']),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,),
            AnimatedContainer(
                height : _height,
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20),
                duration: Duration(microseconds: 2000),
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/30),
                        child: TextFormField(
                        controller: _textController,
                        decoration: InputDecoration(
                        labelText: "Address",
                        helperText: "You can also long press and drag the marker",
                        border: OutlineInputBorder()
                        ),
                        onFieldSubmitted: (val){

                          Geolocator().placemarkFromAddress(val).then((position){
                            if(position!=null){
                            print("old ${currentUser.addresses}");
                            
                              _travelMap(position[0].position.latitude,position[0].position.longitude);
                              _addval = {
                                'lat' : position[0].position.latitude.toDouble(),
                                'long' : position[0].position.longitude.toDouble(),
                                'address' : position[0].name
                              };
                            _newaddress.clear();
                              _newaddress.putIfAbsent('lat', () => position[0].position.latitude);
                              _newaddress.putIfAbsent('long', () => position[0].position.longitude);
                              _newaddress.putIfAbsent('address', () => val);
                            print("new ${currentUser.addresses}");
                          };
                          });
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/40),
                    _returnButtonOrLoading(_loading),
                    
                  ]
                ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/30,),
            Text('Saved Addresses',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),),
            SizedBox(height: MediaQuery.of(context).size.height/30,),
            ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(
                parent : NeverScrollableScrollPhysics(),
              ),
              itemCount: currentUser.addresses.keys.length,
              itemBuilder: (BuildContext context,int index){
                return ListTile(
                  trailing: IconButton(icon: Icon(Icons.delete), onPressed: (){
                    setState(() {
                      DatabaseService(uid: currentUserID).deleteAddress(currentUser.addresses.keys.elementAt(index));
                    });
                  }),
                  title: Text(currentUser.addresses[currentUser.addresses.keys.elementAt(index)]['address']),
                  leading: Radio<Map>(
                  value: currentUser.addresses[currentUser.addresses.keys.elementAt(index)], 
                  groupValue: _addval,
                  onChanged: (Map val){
                    setState((){
                      _addval = val;
                      _travelMap(_addval['lat'],_addval['long']);
                    });
                  }
                )
                );
              },
            ),
            
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: white),
        backgroundColor: base,
        onPressed: (){
          setState(() {
            _height = MediaQuery.of(context).size.height/4;
          });
        },
      ),
    );
  }
}