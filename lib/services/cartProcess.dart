import 'package:bake2home/constants.dart';

class CartProcess{

  void addItem(Map item,String vid){
    if(cartShopId==null){
      cartShopId = item['itemId'];
    }
    if(cartMap[vid] != null){
      cartMap[vid]['quantity']++;
    }else{
      cartMap[vid].addEntries([
        MapEntry('size', item['variants'][vid]['size']),
        MapEntry('price', item['variants'][vid]['price']),
        MapEntry('photoUrl', item['photoUrl']),
        MapEntry('itemName', item['itemName']),
        MapEntry('quantity', item['quantity']),
      ]);
    }
  }   

  void removeItem(Map item,String vid){
    cartMap[vid]['quantity']--;
    if(cartMap[vid]['quantity']==0){
      cartMap.remove(vid);
    }
    if(cartMap.length==0){
      cartShopId = null;
    }
  }
}