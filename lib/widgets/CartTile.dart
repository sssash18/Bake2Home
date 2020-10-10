import 'package:bake2home/functions/customisedItemModel.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/screens/ItemPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CartTile extends StatefulWidget {
  Map item;
  Shop shop;
  int length;
  String vid;
  CartTile({this.length, this.item, this.shop, this.vid});

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  int quantity;
  ProgressDialog pr;
  bool customItem;
  @override
  void initState() {
    super.initState();

    print(quantity);
  }

  @override
  Widget build(BuildContext context) {
    quantity = this.widget.item['quantity'];
    double width = MediaQuery.of(context).size.width - 20;
    double height = MediaQuery.of(context).size.height;
    customItem = widget.vid.startsWith(widget.shop.shopId) ? true : false;
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Updating Item...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Center(child: CircularProgressIndicator()),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    return InkWell(
      onTap: () async {
        if (this.widget.vid.split('-')[0] == this.widget.shop.shopId) {
          CustomisedItemModel model;
          String id =
              '${this.widget.vid.split('-')[0]}-${this.widget.vid.split('-')[1]}';
          ProgressDialog pr1 = ProgressDialog(context,
              type: ProgressDialogType.Normal,
              isDismissible: true,
              showLogs: true);
          pr1.style(
              message: 'Please Wait...',
              borderRadius: 10.0,
              backgroundColor: Colors.white,
              progressWidget: Center(child: CircularProgressIndicator()),
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
          await pr1.show();
          await FirebaseFirestore.instance
              .collection('Shops')
              .doc(this.widget.shop.shopId)
              .get()
              .then((v) {
            Map<String, dynamic> value = Map.from(v.data()['items']
                    [this.widget.item['itemCategory']]
                [this.widget.item['itemType']][id.toString()]);
            Map<String, dynamic> dup = value['variants'];
            Map<String, dynamic> variants = Map();
            Map<String, dynamic> idtoprice = Map();
            dup.forEach((key, value) {
              idtoprice.putIfAbsent(key, () => value['price']);
            });
            List<dynamic> prices = idtoprice.values.toList();
            prices.sort((a, b) {
              return a.compareTo(b);
            });
            prices.forEach((element) {
              idtoprice.forEach((key, value) {
                if (value == element) {
                  variants.putIfAbsent(key, () => dup[key]);
                }
              });
            });
            model = CustomisedItemModel(
                itemId: value['itemId'],
                ingredients: List<String>.from(value['ingredients']),
                itemName: value['itemName'],
                itemCategory: value['itemCategory'],
                photoUrl: value['photoUrl'],
                recipe: value['recipe'],
                minTime: value['minTime'].toDouble(),
                variants: variants,
                veg: value['veg'],
                flavours: List<String>.from(value['flavours']));
          });
          await pr1.hide();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemPage(
                      itemType: this.widget.item['itemType'],
                      category: this.widget.item['itemCategory'],
                      shopId: this.widget.shop.shopId,
                      model: model)));
        }
      },
      child: Container(
        height: width * 0.25,
        width: width,
        margin: EdgeInsets.symmetric(vertical: 7.5),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(border),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, offset: Offset(0.0, 1.0), blurRadius: 3.0)
            ]),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: width * 0.25,
                  width: width * 0.25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(border),
                      image: DecorationImage(
                          image: widget.item['photoUrl'] != null
                              ? CachedNetworkImageProvider(
                                  widget.item['photoUrl'],
                                )
                              : AssetImage("assets/images/cake.jpeg"),
                          fit: BoxFit.fill))),
              Container(
                  width: width * 0.65,
                  height: width * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        widget.item['itemName'],
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      Text(
                        'by ${widget.shop.shopName}',
                        style: TextStyle(fontSize: 10.0),
                      ),
                      customItem
                          ? Text(
                              '\u20B9 ${widget.item['price'] * widget.item['quantity']}',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "Price Not included till yet",
                              style: TextStyle(fontSize: 10),
                            )
                    ],
                  )),
              !customItem
                  ? Container(
                      width: width * 0.1,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              child: Icon(Icons.delete),
                              onTap: () async {
                                await pr.show();
                                if (widget.length != 1) {
                                  await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(currentUser.uid)
                                      .update({
                                    'cart.${widget.vid}': FieldValue.delete(),
                                  }).then((value) async {
                                    await pr.hide();
                                  }).catchError((e) async {
                                    await pr.hide();
                                    print(e.toString());
                                  });
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(currentUser.uid)
                                      .update({
                                    'cart': {},
                                  }).then((value) async {
                                    await pr.hide();
                                  }).catchError((e) async {
                                    await pr.hide();
                                    print(e.toString());
                                  });
                                }
                              },
                            )
                          ]),
                    )
                  : Container(
                      width: width * 0.1,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                print(quantity);
                                addToCartNewItem();
                              },
                              child: Icon(
                                Icons.add_circle_outline,
                                color: base,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                              child: Text('$quantity'),
                            ),
                            InkWell(
                              onTap: () {
                                dropItem(context);
                                print(this.widget.item);
                                print(cartMap);
                              },
                              child: Icon(
                                Icons.remove_circle_outline,
                                color: base,
                              ),
                            ),
                          ]),
                    )
            ]),
      ),
    );
  }

  Future<void> addToCartNewItem() async {
    bool note = true;
    String noteItem = "";
    if (note) {
      showModalBottomSheet(
          context: context,
          builder: (builder) {
            return Container(
              child: Form(
                child: Column(children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height / 30),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.height / 30,
                        0,
                        MediaQuery.of(context).size.height / 30,
                        0),
                    child: TextFormField(
                      autofocus: true,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton.icon(
                          color: base,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(border),
                          ),
                          onPressed: () async {
                            await pr.show();
                            setState(() {
                              quantity++;
                              cartMap[widget.vid]['quantity']++;
                              cartMap[widget.vid]['notes'].add(noteItem);
                              print(cartMap);
                            });
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(currentUser.uid)
                                .update({
                              'cart': cartMap,
                            }).then((value) async {
                              await pr.hide();
                            }).catchError((e) async {
                              await pr.hide();
                              print(e.toString());
                            });
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.done,
                            color: white,
                          ),
                          label: Text(
                            'Done',
                            style: TextStyle(color: white),
                          )),
                      FlatButton.icon(
                          color: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(border),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.clear,
                            color: white,
                          ),
                          label: Text(
                            'Cancel',
                            style: TextStyle(color: white),
                          ))
                    ],
                  )
                ]),
              ),
            );
          });
    }
  }

  Future<void> dropItem(BuildContext context) async {
    List<String> notes = List.from(this.widget.item['notes']);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffeaafc8), Color(0xff654ea3)]),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(notes.length, (index) {
                return ListTile(
                  title: Text(
                    notes[index],
                    style: TextStyle(color: white, fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: white,
                    ),
                    onPressed: () async {
                      bool rs = await genDialog(context,
                          "Are you sure to remove the item", "Yes", "No");
                      if (rs) {
                        print('------------> ${widget.item}');
                        // setState(() {
                        --quantity;
                        // });
                        if (quantity == 0) {
                          await pr.show();
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(currentUser.uid)
                              .update({
                            'cart.${widget.vid}': FieldValue.delete(),
                          }).then((value) async {
                            await pr.hide();
                          }).catchError((e) async {
                            await pr.hide();
                            print(e.toString());
                          });
                          Navigator.pop(context);
                        } else {
                          Map<String, dynamic> item =
                              Map.from(this.widget.item);
                          notes.removeAt(index);
                          item.update('quantity', (value) => quantity);
                          item.update('notes', (value) => notes);
                          // cartMap.update(this.widget.vid, (value) => item);
                          await pr.show();
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(currentUser.uid)
                              .update({
                            'cart.${widget.vid}': item,
                          }).then((value) async {
                            await pr.hide();
                          }).catchError((e) async {
                            await pr.hide();
                            print(e.toString());
                          });
                          Navigator.pop(context);
                          // setState(() {});
                          // if (quantity == 0) {
                          //   await pr.show();
                          //   await FirebaseFirestore.instance
                          //       .collection('Users')
                          //       .doc(currentUser.uid)
                          //       .update({
                          //     'cart.${widget.vid}': FieldValue.delete(),
                          //   }).then((value) async {
                          //     await pr.hide();
                          //   }).catchError((e) async {
                          //     await pr.hide();
                          //     print(e.toString());
                          //   });
                          //   Navigator.pop(context);
                          // } else {
                          //   Map<String, dynamic> item =
                          //       Map.from(this.widget.item);
                          //   notes.removeAt(index);
                          //   item.update('quantity', (value) => quantity);
                          //   item.update('notes', (value) => notes);
                          //   cartMap.update(this.widget.vid, (value) => item);
                          //   await pr.show();
                          //   await FirebaseFirestore.instance
                          //       .collection('Users')
                          //       .doc(currentUser.uid)
                          //       .update({
                          //     'cart': cartMap,
                          //   }).then((value) async {
                          //     await pr.hide();
                          //   }).catchError((e) async {
                          //     await pr.hide();
                          //     print(e.toString());
                          //   });
                          //   Navigator.pop(context);
                          // }
                        }
                      }
                    },
                  ),
                );
              }),
            ),
          );
        });
  }
}
