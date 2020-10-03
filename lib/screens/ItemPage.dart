import 'dart:collection';

import 'package:bake2home/functions/cartItem.dart';
import 'package:bake2home/functions/customisedItemModel.dart';
import 'package:bake2home/screens/addCustomProduct.dart';
import 'package:bake2home/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';

class ItemPage extends StatefulWidget {
  CustomisedItemModel model;
  String shopId;
  ItemPage({this.shopId, this.model});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  String _price = '100';
  String vid;
  GlobalKey _key = GlobalKey<ScaffoldState>();
  int quantity = 0;
  SplayTreeSet<double> dropDownList = SplayTreeSet();
  Map<double, double> priceMap = new Map();
  Map<double, String> vidMap = new Map();
  double selectedSize = 0.0, price, tt;
  @override
  Widget build(BuildContext context) {
    vidMap.clear();
    priceMap.clear();
    dropDownList.clear();
    this.widget.model.variants.forEach((key, value) {
      print("VVVVVVV" + value.toString());
      String vid = value['vid'];
      double price = value['price'].toDouble();
      double size = value['size'].toDouble();
      priceMap.putIfAbsent(size, () => price);
      dropDownList.add(size);
      vidMap.putIfAbsent(size, () => vid);
    });
    tt = selectedSize == 0.0 ? dropDownList.first : selectedSize;
    price = priceMap[tt];
    vid = vidMap[tt];
    if (cartMap.containsKey(vid)) {
      quantity = cartMap[vid]['quantity'];
    } else {
      quantity = 0;
    }
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          DatabaseService(uid: currentUserID).updateCart(cartMap);
          return true;
        },
        child: Scaffold(
          key: _key,
          resizeToAvoidBottomInset: true,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: white),
            backgroundColor: base,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProduct(
                        shop: shopMap[widget.shopId],
                        itemType: widget.model.itemCategory),
                  ));
            },
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Stack(overflow: Overflow.visible, children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.8,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff654ea3), Color(0xffeaafc8)],
                    )),
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.black.withOpacity(1.0),
                            Colors.black.withOpacity(1.0),
                            Colors.black.withOpacity(0.1),
                            Colors
                                .transparent // <-- you might need this if you want full transparency at the edge
                          ],
                          stops: [
                            0.0,
                            0.5,
                            0.65,
                            1.0
                          ], //<-- the gradient is interpolated, and these are where the colors above go into effect (that's why there are two colors repeated)
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, 1.5 * rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: widget.model.photoUrl != null
                          ? CachedNetworkImage(
                              imageUrl: widget.model.photoUrl,
                              fit: BoxFit.fill,
                            )
                          : Image.asset("assets/images/cake.jpeg",
                              fit: BoxFit.fill),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2.8 -
                        MediaQuery.of(context).size.height / 16,
                    left: (MediaQuery.of(context).size.width -
                            MediaQuery.of(context).size.width / 1.3) /
                        2,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 16.0,
                          )
                        ],
                      ),
                      height: MediaQuery.of(context).size.height / 8,
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.model.itemName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25.0),
                                ),
                            ),
                          ),
                          Container(
                            child: Image.asset(widget.model.veg==true ? "assets/images/veg.png" : "assets/images/noon.png",height: 20,),
                            margin: EdgeInsets.only(right: 10),
                          )
                        ]
                      ),
                    ),
                  ),
                  Positioned(
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: white,
                          size: 40.0,
                        ),
                        onPressed: () {
                          DatabaseService(uid: currentUserID)
                              .updateCart(cartMap);
                          Navigator.pop(context);
                        }),
                    top: 0,
                    left: 0,
                  ),
                ]),
              ),
              SliverToBoxAdapter(
                  child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffeaafc8), Color(0xff654ea3)],
                )),
                child: Column(
                  children: <Widget>[
                    quantity == 0.0 ? cartAdder(context) : cartAdded(context),
                    Container(
                        margin: EdgeInsets.fromLTRB(15.0, 45.0, 0, 0),
                        alignment: Alignment.topLeft,
                        child: Text("Ingredients",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontSize: head2,
                            ))),
                    Container(
                      margin: EdgeInsets.fromLTRB(15.0, 15.0, 0, 0),
                      child: ListView.builder(
                          physics: ScrollPhysics(
                            parent: NeverScrollableScrollPhysics(),
                          ),
                          shrinkWrap: true,
                          itemCount: widget.model.ingredients.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                                '${widget.model.ingredients.elementAt(index)}',
                                style: TextStyle(
                                  color: white,
                                  fontSize: textSize,
                                ));
                          }),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(15.0, 45.0, 15.0, 0),
                        alignment: Alignment.topLeft,
                        child: Text("Description",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontSize: head2,
                            ))),
                    Container(
                        margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                        child: Text(
                          widget.model.recipe,
                          style: TextStyle(color: white, fontSize: textSize),
                        )),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Container cartAdder(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.08;
    double width = MediaQuery.of(context).size.width * 0.9;
    return Container(
      margin: EdgeInsets.only(top: 60.0),
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2.5,
                blurRadius: 2.5)
          ]),
      child: Row(children: <Widget>[
        Container(
            width: width / 2,
            decoration: BoxDecoration(
                // color: Colors.pink,
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            )),
            child: Center(
              child: dButton(),
            )),
        InkWell(
          onTap: () {
            addToCartNewItem();
          },
          child: Container(
            width: width / 2,
            decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                )),
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.add_shopping_cart),
                Text("Add to cart"),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  dButton() {
    List<DropdownMenuItem<double>> list = List();
    dropDownList.forEach((element) {
      list.add(DropdownMenuItem<double>(
        value: element,
        child: Text("$element pounds  \u20B9 ${priceMap[element]}",
            style: TextStyle(color: black)),
      ));
    });
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        isDense: false,
        // focusNode: dropFocus,
        items: list,
        value: selectedSize == 0.0 ? dropDownList.first : selectedSize,
        style: TextStyle(fontSize: 13.0),
        onChanged: (value) {
          // FocusScope.of(context).requestFocus(new FocusNode());
          setState(() {
            selectedSize = value;
            // price = myMap[selectedSize];
            // if (cartMap.containsKey(idMap[selected])) {
            //   quantity = cartMap[idMap[selected]]['quantity'];
            // } else {
            //   quantity = 0;
            // }
          });
        },
      ),
    );
  }

  Future<void> addToCartNewItem() async {
    List<DropdownMenuItem<String>> flavourDrop = new List();
    this.widget.model.flavours.forEach((element) {
      print(element);
      flavourDrop
          .add(DropdownMenuItem<String>(child: Text(element), value: element));
    });
    bool note = true;
    String noteItem = "";
    String shopId;
    String flavourSelected = flavourDrop[0].value;
    if (cartMap['shopId'] == null) {
      shopId = 'null';
    } else {
      shopId = cartMap['shopId'];
    }
    flavourDrop.forEach((element) {
      print('++++++++++++++${element.value}');
    });
    if (shopId == 'null' || this.widget.shopId == shopId) {
      if (note) {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (builder) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Form(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height / 30),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: "Special Note",
                            helperText: "* will be printed on the product",
                            border: OutlineInputBorder()),
                        onChanged: (val) {
                          noteItem = val;
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 100),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        width: MediaQuery.of(context).size.width - 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: black)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: flavourDrop,
                            value: flavourSelected,
                            onChanged: (value) {
                              setState(() {
                                flavourSelected = value;
                              });
                            },
                          ),
                        )),
                    SizedBox(height: MediaQuery.of(context).size.height / 100),
                    FlatButton.icon(
                        color: base,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(border),
                        ),
                        onPressed: () async {
                          setState(() {
                            quantity++;
                            if (quantity == 1) {
                              CartItemMap cartItem = CartItemMap(
                                  itemName: widget.model.itemName,
                                  quantity: quantity,
                                  size: tt,
                                  notes: [noteItem],
                                  price: price,
                                  minTime: widget.model.minTime,
                                  photoUrl: widget.model.photoUrl,
                                  flavour: flavourSelected);
                              cartMap.putIfAbsent(
                                  vid,
                                  () => {
                                        'itemName': cartItem.itemName,
                                        'size': cartItem.size,
                                        'price': cartItem.price,
                                        'quantity': cartItem.quantity,
                                        'notes': cartItem.notes,
                                        'photoUrl': cartItem.photoUrl,
                                        'minTime': cartItem.minTime,
                                        'flavour': cartItem.flavour,
                                      });
                              cartMap.putIfAbsent(
                                  'shopId', () => widget.shopId);
                            } else {
                              cartMap[vid]['quantity']++;
                              cartMap[vid]['notes'].add(noteItem);
                            }
                            print(cartMap);
                            Navigator.pop(context);
                            showSnackBar(_key, "Item Added to Cart");
                          });
                        },
                        icon: Icon(
                          Icons.done,
                          color: white,
                        ),
                        label: Text(
                          'Done',
                          style: TextStyle(color: white),
                        )),
                    SizedBox(height: MediaQuery.of(context).size.height / 100),
                  ]),
                ),
              );
            });
      }
    } else {
      bool rs = await genDialog(
          context,
          "Cart already has items from another shops \n Adding new items would remove any items previously added",
          'Clear Cart',
          'Cancel');
      if (rs) {
        cartMap.clear();
      }
    }
  }

  cartAdded(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.08;
    double width = MediaQuery.of(context).size.width * 0.9;
    return Container(
      margin: EdgeInsets.only(top: 60.0),
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2.5,
                blurRadius: 2.5)
          ]),
      child: Row(children: <Widget>[
        Container(
            width: width / 2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
            )),
            child: Center(
              child: dButton(),
            )),
        InkWell(
          child: Container(
            width: width / 2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            )),
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: Colors.black,
                  ),
                  onTap: () {
                    setState(() {
                      --quantity;
                      cartMap[vid]['quantity']--;
                      cartMap[vid]['notes'].removeLast();
                      if (cartMap[vid]['quantity'] == 0) {
                        cartMap.remove(vid);
                      }
                    });
                  },
                ),
                Text('$quantity'),
                InkWell(
                  onTap: () {
                    setState(() {
                      ++quantity;
                      addToCartNewItem();
                    });
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
