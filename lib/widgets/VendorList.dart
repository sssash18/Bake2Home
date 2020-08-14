import 'package:bake2home/screens/VendorProfile.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/VendorTile.dart';

class VendorList extends StatefulWidget {
  @override
  _VendorListState createState() => _VendorListState();
}

class _VendorListState extends State<VendorList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
          itemCount: shopMap.length,
          itemBuilder: (BuildContext context,int index){
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => VendorProfile(shop: shopMap[shopMap.keys.elementAt(index)]),
                ));
              },
              child: VendorTile(shop: shopMap[shopMap.keys.elementAt(index)],)
            );
          }
        );
  }
}