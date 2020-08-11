import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/screens/ItemPage.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/ItemTile.dart';

class ItemList extends StatefulWidget {

  final String itemType;
  final Shop shop;

  ItemList({this.itemType,this.shop,});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {

  final _tabs = <Widget>[
    Tab(
      text: "Customised",
    ),
    Tab(
      text: "Standard",
    )
  ];

  Map _items = new Map();

  @override
  void initState() {
    super.initState();
    _items = widget.shop.items[widget.itemType]['customised'];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
        appBar: AppBar(
          title: Text(widget.itemType,style: TextStyle(color: base),),
          iconTheme: IconThemeData(
            color: text,
          ),
          backgroundColor: white,
          bottom: TabBar(
            tabs: _tabs,
            onTap: (int index){
             setState((){
               if(index == 0){
                _items = widget.shop.items[widget.itemType]['customised'];
              }else{
                _items = widget.shop.items[widget.itemType]['standard'];
              }
                
             });
            }  
          ),
        ),
        body: ListView.builder(
        itemCount: _items.keys.length,
        itemBuilder: (BuildContext context,int index){
          return GestureDetector(
            child: ItemTile(item: _items[_items.keys.elementAt(index)]),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ItemPage(item: _items[_items.keys.elementAt(index)])));
            },
          );
        }
      )
        
      ),
    );
  }
}