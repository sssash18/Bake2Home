import 'dart:async';

import 'package:bake2home/services/database.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  //center location
  Map _addval = {'lat': 23.344888, 'long': 75.0352145, 'add': 'mera ghar'};
  bool _loading = false;
  String addTyped = '';
  double _height = 0;
  bool locationPresent = false;
  bool floatingVisible = true;
  Completer<GoogleMapController> _controller = Completer();
  Map _newaddress = Map();
  String _addressNew = "";
  TextEditingController _textController = TextEditingController(text: "");
  bool typed = false;
  Widget _returnButtonOrLoading(bool loading) {
    if (loading) {
      return CircularProgressIndicator();
    }
    return locationPresent
        ? FlatButton.icon(
            onPressed: () async {
              setState(() {
                _loading = true;
              });
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
                await DatabaseService(uid: currentUserID)
                    .addAddress(_newaddress)
                    .then((value) {
                  setState(() {
                    _height = 0;
                    _loading = false;
                    addTyped = '';
                    typed = true;
                    locationPresent = false;
                    floatingVisible = true;
                  });
                }).catchError((e) {
                  showSnackBar(mapKey, "Error Encountered,Try Again Later");
                });
              } else {
                showSnackBar(mapKey, "Service not available at this address");
                setState(() {
                  _loading = false;
                });
              }
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

  final mapKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mapKey,
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(
          color: base,
        ),
        title: Text("Manage Addresses", style: TextStyle(color: base)),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height / 2.2,
            width: MediaQuery.of(context).size.width,
            child:
                _returnMap(_addval['lat'], _addval['long'], _addval['address']),
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
                                    .placemarkFromAddress('$addTyped ratlam')
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
                                  showSnackBar(
                                      mapKey, 'No Such  Location Found');
                                });
                              },
                              child: Icon(Icons.check, color: base),
                            )
                          : null,
                      labelText: "Address",
                      helperText: "You can also long press and drag the marker",
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
                      showSnackBar(mapKey, 'No Such  Location Found');
                      print(e.toString());
                    });
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              _returnButtonOrLoading(_loading),
            ]),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 30,
          ),
          Text(
            'Saved Addresses',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 30,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(
              parent: NeverScrollableScrollPhysics(),
            ),
            itemCount: currentUser.addresses.keys.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          DatabaseService(uid: currentUserID).deleteAddress(
                              currentUser.addresses.keys.elementAt(index));
                        });
                      }),
                  title: Text(currentUser.addresses[
                      currentUser.addresses.keys.elementAt(index)]['address']),
                  leading: Radio<Map>(
                      value: currentUser.addresses[
                          currentUser.addresses.keys.elementAt(index)],
                      groupValue: _addval,
                      onChanged: (Map val) {
                        setState(() {
                          _addval = val;
                          _travelMap(_addval['lat'], _addval['long']);
                        });
                      }));
            },
          ),
        ]),
      ),
      floatingActionButton: floatingVisible
          ? FloatingActionButton(
              child: Icon(Icons.add, color: white),
              backgroundColor: base,
              onPressed: () {
                setState(() {
                  floatingVisible = false;
                  _height = MediaQuery.of(context).size.height / 4;
                });
              },
            )
          : SizedBox.shrink(),
    );
  }
}
