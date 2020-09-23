import 'package:bake2home/constants.dart';

class ShopSearch{
  final String shopName;
  final String shopId;
  ShopSearch({this.shopId,this.shopName});
}

class ItemSearch{
  final String itemId;
  final String itemName;
  ItemSearch({this.itemId,this.itemName});
}

List<ShopSearch> loadShopSearch(){
  List<ShopSearch> shops;
  shopMap.keys.forEach((element) {
    shops.add(ShopSearch(shopId: shopMap[element].shopId,shopName: shopMap[element].shopName));
   });
  return shops;
}

List<ItemSearch> loadItemSearch(){
  List<ItemSearch> items;
  shopMap.keys.forEach((element) { 
    shopMap[element].items.forEach((key, value) { 
      
    });
  });
}
