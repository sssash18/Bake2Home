import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';

class CartTile extends StatefulWidget {

  Map item;
  String shopName,vid; 
  CartTile({this.item,this.shopName,this.vid});

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      height: 90.0,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(border),
        boxShadow: [BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 3.0
        )]
      ),
      
      child: Row(
        children: <Widget>[
          
          Container(
            height: 90.0,
            width: 90.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(border),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  widget.item['photoUrl'],
                ),
                fit: BoxFit.fill
              )
            )
          ),
          Expanded(
              child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: Text(
                      widget.item['itemName'],
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                      child: Text(
                      'by ${widget.shopName}',
                      style: TextStyle(
                        fontSize: 10.0
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                      child: Text(
                      '\u20B9 ${widget.item['price'] * widget.item['quantity']}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              )
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5.0, 20, 0),
            alignment: Alignment.centerRight,
            //height: 90.0,
            child: Column(
              children: <Widget>[
                // IconButton(
                //   padding: EdgeInsets.all(0),
                //   iconSize: 20,
                //   icon : Icon(Icons.add_circle_outline,color: base,),
                //   onPressed: (){
                //     addToCartNewItem();
                //   },
                // ),
                InkWell(
                    onTap: (){},
                    child: Icon(
                    Icons.add_circle_outline,
                    color: base,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0,5.0, 0, 5.0),
                  child: Text(widget.item['quantity'].toString()),
                ),
                InkWell(
                    onTap: (){},
                    child: Icon(
                    Icons.remove_circle_outline,
                    color: base,
                  ),
                ),
              ]
            ),
          )

        ]
      ),
      
    );
  }

  void addToCartNewItem() {
    bool note = true;
    String noteItem = "";
    if(note){
      showModalBottomSheet( 
        context: context,
        builder: (builder){
          return Container(
            child: Form(
            child: Column(
              children : <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height/30),
                Container(
                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height/30,0, MediaQuery.of(context).size.height/30, 0),
                    child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: "Special Note",
                      helperText: "* will be printed on the product",
                      border: OutlineInputBorder()
                    ), 
                    onChanged: (val){
                      noteItem = val;
                    }, 
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height/100),
                FlatButton.icon(
                  color: base,
                  shape: RoundedRectangleBorder(
                    borderRadius : BorderRadius.circular(border),
                  ),
                  onPressed: (){
                   setState(() {
                      // quantity++;
                      // if(quantity==1){
                      //   CartItemMap cartItem = CartItemMap(
                      //     itemName: widget.model.itemName,
                      //     quantity: quantity,
                      //     size: tt,
                      //     notes: [noteItem],
                      //     price: price,
                      //     photoUrl: widget.model.photoUrl
                      //   );
                      //   cartMap.putIfAbsent(widget.vid,() => {
                      //     'itemName' : cartItem.itemName,
                      //     'size'  : cartItem.size,
                      //     'price' : cartItem.price,
                      //     'quantity' : cartItem.quantity,
                      //     'notes' : cartItem.notes,
                      //     'photoUrl' : cartItem.photoUrl
                      //   });
                      // }else{
                      //   cartMap[widget.vid]['quantity']++;
                      //   cartMap[widget.vid]['notes'].add(noteItem);
                      // }
                      print(cartMap);
                      Navigator.pop(context);
                   }); 

                  },
                  icon: Icon(Icons.done,color: white,),
                  label: Text('Done',style: TextStyle(color : white),)
                )
              ]
            ), 
              ),
          );
        }
      );
    }
  }
}