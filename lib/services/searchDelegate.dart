import 'package:bake2home/constants.dart';
import 'package:bake2home/functions/customisedItemModel.dart';
import 'package:bake2home/functions/searchList.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/screens/ItemList.dart';
import 'package:bake2home/screens/ItemPage.dart';
import 'package:bake2home/screens/VendorProfile.dart';
import 'package:flutter/material.dart';

class searchDelegate extends SearchDelegate<Shop> {
  List<Shop> shopSearch = [];
  List<Map> itemSearch = [];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Shop> shops = [];
    final List<Map> itemList = [];
    shopMap.keys.forEach((element) {
      shops.add(shopMap[element]);
      shopMap[element].items.forEach((key, value) {
        Map itemMap = shopMap[element].items[key]; //Cake ,cookie
        Map standard = itemMap['standard'];
        Map customised = itemMap['customised'];
        standard.keys.forEach((element) {
          //print(standard[element]);
          itemList.add(standard[element]);
        });
        customised.keys.forEach((element) {
          itemList.add(customised[element]);
          //print(customised[element]);
        });
      });
    });
    print(itemList[0]['itemName']);
    shopSearch = query.isEmpty
        ? shops
        : shops
            .where(
                (e) => e.shopName.toLowerCase().contains(query.toLowerCase()))
            .toList();
    itemSearch = query.isEmpty
        ? itemList
        : itemList
            .where((e) => e['itemName']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
        itemCount: shopSearch.length + itemSearch.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < shopSearch.length) {
            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            VendorProfile(shop: shopSearch[index])));
              },
              title: Text(shopSearch[index].shopName),
            );
          }
          String shopId = itemSearch[index - shopSearch.length]['itemId']
              .toString()
              .split("-")[0];
          CustomisedItemModel item = CustomisedItemModel(
              // availability: itemList[index - shopSearch.length]['availability'],
              itemId: itemList[index - shopSearch.length]['itemId'],
              minTime:
              itemList[index - shopSearch.length]['minTime'].toDouble(),
              // ingPrice: itemList[index - shopSearch.length]['ingPrice'].toDouble(),
              ingredients:
                  List.from(itemList[index - shopSearch.length]['ingredients']),
              itemName: itemList[index - shopSearch.length]['itemName'],
              photoUrl: itemList[index - shopSearch.length]['photoUrl'],
              recipe: itemList[index - shopSearch.length]['recipe'],
              veg: itemList[index - shopSearch.length]['veg'],
              itemCategory: itemList[index - shopSearch.length]['itemCategory'],
               itemType: itemList[index - shopSearch.length]['itemType'],
              flavours: List<String>.from(itemList[index - shopSearch.length]['flavours']),
              variants: itemList[index - shopSearch.length]['variants']);
          return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ItemPage(
                            shopId: shopId,
                            model: item,
                            itemType: item.itemType,
                            category: item.itemCategory,
                            
                          )));
            },
            title: Text(itemList[index - shopSearch.length]['itemName']),
            subtitle: Text('by ${shopMap[shopId].shopName}'),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Shop> shops = [];
    final List<Map> itemList = [];
    shopMap.keys.forEach((element) {
      shops.add(shopMap[element]);
      shopMap[element].items.forEach((key, value) {
        Map itemMap = shopMap[element].items[key]; //Cake ,cookie
        Map standard = itemMap['standard'];
        Map customised = itemMap['customised'];
        standard.keys.forEach((element) {
          //print(standard[element]);
          itemList.add(standard[element]);
        });
        customised.keys.forEach((element) {
          itemList.add(customised[element]);
          //print(customised[element]);
        });
      });
    });
    print(itemList[0]['itemName']);
    shopSearch = query.isEmpty
        ? shops
        : shops
            .where(
                (e) => e.shopName.toLowerCase().contains(query.toLowerCase()))
            .toList();
    itemSearch = query.isEmpty
        ? itemList
        : itemList
            .where((e) => e['itemName']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
        itemCount: shopSearch.length + itemSearch.length,
        itemBuilder: (BuildContext context, int index) {
          if (index < shopSearch.length) {
            return ListTile(
              onTap: () {
                showResults(context);
              },
              title: Text(shopSearch[index].shopName),
            );
          }
          String shopId = itemSearch[index - shopSearch.length]['itemId']
              .toString()
              .split("-")[0];
          return ListTile(
            onTap: () {
              showResults(context);
            },
            title: Text(itemList[index - shopSearch.length]['itemName']),
            subtitle: Text('by ${shopMap[shopId].shopName}'),
          );
        });
  }
}
