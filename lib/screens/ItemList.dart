import 'package:bake2home/screens/ItemPage.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/ItemTile.dart';

class ItemList extends StatelessWidget {

  final _tabs = <Widget>[
    Tab(
      text: "Customised",
    ),
    Tab(
      text: "Standard",
    )
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
        appBar: AppBar(
          title: Text("Cakes",style: TextStyle(color: base),),
          iconTheme: IconThemeData(
            color: text,
          ),
          backgroundColor: white,
          bottom: TabBar(tabs: _tabs),
        ),
        body: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context,int index){
          return GestureDetector(child: ItemTile(),onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ItemPage()));
          },);
        }
      )
        
      ),
    );
  }
}