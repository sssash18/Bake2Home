import 'dart:async';

import 'package:bake2home/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegisterAddress extends StatefulWidget {
  @override
  _RegisterAddressState createState() => _RegisterAddressState();
}

class _RegisterAddressState extends State<RegisterAddress> {
  //center coordinates
  Map _addval = {'lat': 23.344888, 'long': 75.0352145, 'add': 'mera ghar'};
  bool _loading = false;
  String addTyped = '';
  double _height = 0;
  bool locationPresent = false;
  Completer<GoogleMapController> _controller = Completer();
  Map _newaddress = Map();
  String _addressNew = "";
  TextEditingController _textController = TextEditingController(text: "");
  bool typed = false;
  final registerMapKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height / 4;
    return Scaffold(
      key: registerMapKey,
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: base,
        ),
        title: Text("Manage Addresses", style: TextStyle(color: base)),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          await Future.delayed(Duration(microseconds: 1));
          Navigator.pop(context);
          return true;
        },
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.2,
              width: MediaQuery.of(context).size.width,
              child: _returnMap(
                  _addval['lat'], _addval['long'], _addval['address']),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
            AnimatedContainer(
              height: _height,
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 20),
              duration: Duration(microseconds: 2000),
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 30),
                  child: TextFormField(
                    cursorColor: base,
                    controller: _textController,
                    onChanged: (val) {
                      setState(() {
                        if (typed) {
                          typed = false;
                        }
                        locationPresent = false;
                        addTyped = val;
                      });
                    },
                    decoration: InputDecoration(
                        suffix: !typed
                            ? InkWell(
                                onTap: () async {
                                  print(
                                      '---------value is isisa hisho $addTyped');
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    typed = true;
                                  });
                                  await Geolocator()
                                      .placemarkFromAddress(addTyped)
                                      .then((position) {
                                    setState(() {
                                      locationPresent = true;
                                    });
                                    print('my new postition is $position');
                                    if (position != null) {
                                      // print("old ${currentUser.addresses}");

                                      _travelMap(position[0].position.latitude,
                                          position[0].position.longitude);
                                      _addval = {
                                        'lat': position[0]
                                            .position
                                            .latitude
                                            .toDouble(),
                                        'long': position[0]
                                            .position
                                            .longitude
                                            .toDouble(),
                                        'address': position[0].name
                                      };
                                      _newaddress.clear();
                                      _newaddress.putIfAbsent('lat',
                                          () => position[0].position.latitude);
                                      _newaddress.putIfAbsent('long',
                                          () => position[0].position.longitude);
                                      _newaddress.putIfAbsent(
                                          'address', () => addTyped);
                                      print("new ${currentUser.addresses}");
                                    }
                                  }).catchError((e) {
                                    setState(() {
                                      locationPresent = false;
                                    });
                                    print(e.toString());
                                    showSnackBar(registerMapKey,
                                        'No Such  Location Found');
                                  });
                                },
                                child: Icon(Icons.check, color: base),
                              )
                            : null,
                        labelText: "Address",
                        helperText:
                            "You can also long press and drag the marker",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    onFieldSubmitted: (val) async {
                      print('---------value is isisa hisho $val');
                      await Geolocator()
                          .placemarkFromAddress(val)
                          .then((position) {
                        print('my new postition is $position');
                        if (position != null) {
                          // print("old ${currentUser.addresses}");
                          setState(() {
                            locationPresent = true;
                          });
                          _travelMap(position[0].position.latitude,
                              position[0].position.longitude);
                          _addval = {
                            'lat': position[0].position.latitude.toDouble(),
                            'long': position[0].position.longitude.toDouble(),
                            'address': position[0].name
                          };
                          _newaddress.clear();
                          _newaddress.putIfAbsent(
                              'lat', () => position[0].position.latitude);
                          _newaddress.putIfAbsent(
                              'long', () => position[0].position.longitude);
                          _newaddress.putIfAbsent('address', () => val);

                          print("new ${currentUser.addresses}");
                        }
                      }).catchError((e) {
                        setState(() {
                          locationPresent = false;
                        });
                        showSnackBar(registerMapKey, 'No Such  Location Found');
                        print(e.toString());
                      });
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                _returnButtonOrLoading(_loading, _newaddress),
              ]),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 30,
            ),
          ]),
        ),
      ),
    );
  }

  Widget _returnButtonOrLoading(
      bool loading, Map<dynamic, dynamic> newAddress) {
    if (loading) {
      return CircularProgressIndicator();
    }
    return locationPresent
        ? FlatButton.icon(
            onPressed: () async {
              double startlat, startlong;
              await Geolocator()
                  .placemarkFromAddress("CNI Church Katju Nagar Ratlam")
                  .then((value) {
                startlat = value[0].position.latitude;
                startlong = value[0].position.longitude;
              });
              if (await Geolocator().distanceBetween(startlat, startlong,
                      _newaddress['lat'], _newaddress['long']) <=
                  2759.630859375) {
                setState(() {
                  _loading = true;
                  currentUser.addresses.clear();
                  currentUser.addresses.putIfAbsent(
                      Timestamp.now().microsecondsSinceEpoch.toString(),
                      () => newAddress);
                });
              } else {
                showSnackBar(
                    registerMapKey, "Service not available at this address");
              }
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.done,
              color: white,
            ),
            label: Text("Confirm", style: TextStyle(color: white)),
            color: base,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(border)),
          )
        : FlatButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.done,
              color: white,
            ),
            label: Text("Confirm", style: TextStyle(color: white)),
            color: Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(border)),
          );
  }

  Widget _returnMap(double lat, double longi, String address) {
    final CameraPosition _position =
        CameraPosition(target: LatLng(lat, longi), zoom: 16.4746);
    final marker = Marker(
        markerId: MarkerId('12'),
        draggable: true,
        onDragEnd: (coord) {
          if (coord != null) {
            Geolocator().placemarkFromCoordinates(lat, longi).then((value) {
              setState(() {
                _addressNew =
                    "${value[0].subThoroughfare} ${value[0].subLocality},${value[0].locality} - ${value[0].postalCode},${value[0].country}";
                _textController.text = _addressNew;
              });
              _newaddress.clear();
              _newaddress.putIfAbsent('lat', () => lat);
              _newaddress.putIfAbsent('long', () => longi);
              _newaddress.putIfAbsent('address', () => _addressNew);
            });
          }
        },
        position: LatLng(lat, longi),
        infoWindow: InfoWindow(
          title: "Address",
          snippet: address,
        ));

    Set<Marker> _markers = Set();
    _markers.add(marker);
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _position,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: _markers,
    );
  }

  void _travelMap(double lat, double longi) {
    final Future<GoogleMapController> cont = _controller.future;
    cont.then((value) {
      value.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, longi), zoom: 16.4746)));
    });
  }
}
