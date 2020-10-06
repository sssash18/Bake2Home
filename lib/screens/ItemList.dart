import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/screens/customised.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';

import 'addCustomProduct.dart';

class ItemList extends StatefulWidget {
  final String itemType;
  final Shop shop;

  ItemList({
    this.itemType,
    this.shop,
  });

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList>
    with SingleTickerProviderStateMixin {
  final _tabs = <Widget>[
    Tab(
      text: "Customised",
    ),
    Tab(
      text: "Standard",
    )
  ];

  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('########################## ${widget.shop.shopId}');
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.itemType,
            style: TextStyle(color: base),
          ),
          iconTheme: IconThemeData(
            color: text,
          ),
          backgroundColor: white,
          bottom: TabBar(
            tabs: _tabs,
            controller: tabController,
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: white),
            backgroundColor: base,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProduct(
                        shop: shopMap[widget.shop.shopId],
                        itemType: widget.itemType),
                  ));
            },
          ),
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            CustomisedItem(
              itemType: widget.itemType,
              shop: widget.shop,
              category: 'customised',
            ),
            CustomisedItem(
              itemType: widget.itemType,
              shop: widget.shop,
              category: 'standard',
            ),
          ],
        ));
  }
}
