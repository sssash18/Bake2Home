import 'dart:math';

import 'package:bake2home/constants.dart';
import 'package:bake2home/functions/cartItem.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();

  Shop shop;
  String itemType;
  AddProduct({this.shop, this.itemType});
}

class _AddProductState extends State<AddProduct> {
  String itemId = "${currentShopId}-${DateTime.now().millisecondsSinceEpoch}";
  Map variants = new Map();
  int len = 0;
  bool veg = true;
  List<String> ingredients = [];
  List<String> flavours = [];
  String ingredient = "";
  String photoUrl = '';
  String photoPath = '';
  final _tabs = <Widget>[
    Tab(
      text: "Customised",
    ),
    Tab(
      text: "Standard",
    )
  ];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String description;
  TextEditingController desc;
  TextEditingController name;
  TextEditingController weight;
  TextEditingController flavour;
  bool _loader = false;
  int _num = 0;
  List<DropdownMenuItem> _dropList = [];
  List<DropdownMenuItem> _typeList = [];
  double _size;
  double _price;
  String _selectedCategory = null;
  String _selectedType = null;
  CartItemMap cartItemMap;
  @override
  void initState() {
    super.initState();
    cartItemMap = CartItemMap();
    desc = TextEditingController(text: '');
    weight = TextEditingController(text: '');
    name = TextEditingController(text: '');
    flavour = TextEditingController(text: '');
    _dropList = [];
  }

  File itemPhoto;

  Future<void> _getImage(File file) async {
    PickedFile pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 40);
    if (pickedFile != null) {
      setState(() {
        photoPath = pickedFile.path;
        itemPhoto = File(pickedFile.path);
        print(photoPath);
      });
    }
  }

  Future<void> _uploadPhoto(File _image) async {
    String path;
    path = "items/$itemId.png";
    final storageRef =
        FirebaseStorage().ref().child('${widget.shop.shopName}/$path');
    final uploadTask = storageRef.putFile(_image);
    await uploadTask.onComplete;
    String url = await storageRef.getDownloadURL();
    setState(() {
      photoUrl = url;
    });
  }

  ListView generateFormField(int num) {
    String ingredient = "";
    return ListView.builder(
        physics: ScrollPhysics(
          parent: NeverScrollableScrollPhysics(),
        ),
        shrinkWrap: true,
        itemCount: num,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width / 20,
                MediaQuery.of(context).size.height / 30,
                MediaQuery.of(context).size.width / 20,
                0),
            child: TextFormField(
              cursorColor: base,
              initialValue: "",
              decoration: InputDecoration(
                labelText: "Ingredient",
                prefixIcon: Icon(Icons.list, color: base),
                border: OutlineInputBorder(),
              ),
              onFieldSubmitted: (val) {
                ingredients.add(val);
                print("IIIIIII + ${ingredients}");
              },
              onChanged: (val) {
                ingredient = val;
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print('--------------------------------->$photoPath');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          " Product",
          style: TextStyle(color: base),
        ),
        iconTheme: IconThemeData(
          color: text,
        ),
        backgroundColor: white,
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  bool rs = await genDialog(context,
                      "Are you sure to add item in your cart", "YES", "NO");
                  if (rs) {
                    ProgressDialog pr = ProgressDialog(context,
                        type: ProgressDialogType.Normal,
                        isDismissible: true,
                        showLogs: true);
                    pr.style(
                        message: 'Adding to cart please wait....',
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
                    if (photoPath != '') {
                      await _uploadPhoto(itemPhoto);
                    }
                    cartItemMap = CartItemMap(
                      itemCategory: this.widget.itemType,
                      itemName: name.text,
                      size: double.parse(weight.text),
                      flavour: flavour.text,
                      minTime: 24,
                      photoUrl: photoUrl == '' ? null : photoUrl,
                      notes: [desc.text],
                      color: null,
                      price: 0,
                      quantity: 1,
                    );
                    String timestamp =
                        Timestamp.now().millisecondsSinceEpoch.toString();
                    cartMap.putIfAbsent(
                        timestamp,
                        () => {
                              'itemName': cartItemMap.itemName,
                              'size': cartItemMap.size,
                              'price': cartItemMap.price,
                              'quantity': cartItemMap.quantity,
                              'flavour': cartItemMap.flavour,
                              'itemType': 'customised',
                              'notes': cartItemMap.notes,
                              'photoUrl': cartItemMap.photoUrl,
                              'minTime': cartItemMap.minTime,
                              'veg': veg,
                              'itemCategory': cartItemMap.itemCategory,
                            });
                    cartMap.putIfAbsent('shopId', () => widget.shop.shopId);
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(currentUser.uid)
                        .update({
                      'cart': cartMap,
                    });
                    await pr.hide().then((value) {
                      Navigator.pop(context);
                    });
                  }
                }
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withOpacity(1.0),
                    Colors.black.withOpacity(1.0),
                    Colors.black.withOpacity(0),
                    Colors.transparent,
                  ],
                  stops: [
                    0.0,
                    0.5,
                    0.66,
                    1.0
                  ]).createShader(
                  Rect.fromLTRB(0, 0, rect.width, 1.5 * rect.height));
            },
            blendMode: BlendMode.dstIn,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffeaafc8), Color(0xff654ea3)])),
              height: MediaQuery.of(context).size.height / 2.5,
              alignment: Alignment.center,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: photoPath == ''
                                ? Image.asset(
                                    'assets/images/cake.jpeg',
                                    fit: BoxFit.fitWidth,
                                  )
                                : Image.file(File(photoPath),
                                    fit: BoxFit.fitWidth))),
                    CircleAvatar(
                      backgroundColor: base,
                      child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: white,
                          ),
                          onPressed: () async {
                            await _getImage(itemPhoto);
                          }),
                    )
                  ]),
            ),
          ),
          Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextFormField(
                    validator: (val) {
                      return val.isEmpty ? "Theme cannot be empty" : null;
                    },
                    cursorColor: base,
                    maxLength: 200,
                    maxLines: null,
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: "Theme",
                      hintText: "Ex- Pubg,Coding",
                      prefixIcon: Icon(Icons.description, color: base),
                      border: OutlineInputBorder(),
                    ),
                    controller: name,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextFormField(
                    validator: (val) {
                      return val.isEmpty ? "Description cannot be empty" : null;
                    },
                    cursorColor: base,
                    maxLength: 200,
                    maxLines: null,
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: "Chocochips,Cheesefrosting",
                      labelText: "Toppings",
                      prefixIcon: Icon(Icons.description, color: base),
                      border: OutlineInputBorder(),
                    ),
                    controller: desc,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextFormField(
                    validator: (val) {
                      return val.isEmpty ? "Size cannot be empty" : null;
                    },
                    cursorColor: base,
                    maxLines: null,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: "Size & Tier",
                      hintText: '3 pounds - 2 tier',
                      prefixIcon: Icon(Icons.description, color: base),
                      border: OutlineInputBorder(),
                    ),
                    controller: weight,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextFormField(
                    validator: (val) {
                      return val.isEmpty ? "flavour cannot be empty" : null;
                    },
                    cursorColor: base,
                    maxLines: null,
                    decoration: InputDecoration(
                      counterText: '',
                      labelText: "Flavour",
                      hintText: 'Ex - Chocolate,Butterscotch',
                      prefixIcon: Icon(Icons.description, color: base),
                      border: OutlineInputBorder(),
                    ),
                    controller: flavour,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(children: [
                    Container(
                        child: Text(
                      "Non Veg",
                      style: TextStyle(
                        color: base,
                        fontSize: 18,
                      ),
                    )),
                    Expanded(
                      child: Center(
                        child: Switch(
                          value: veg,
                          onChanged: (val) {
                            setState(() {
                              veg = val;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                        child: Text(
                      "Veg",
                      style: TextStyle(
                        color: base,
                        fontSize: 18,
                      ),
                    )),
                  ]),
                ),
              ]))
        ]),
      ),
    );
  }
}
// desc,photo,flavout,theme -->itemName,pound size,
