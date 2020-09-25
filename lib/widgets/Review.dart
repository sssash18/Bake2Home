import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:in_app_review/in_app_review.dart';
import '../constants.dart';

class Review extends StatefulWidget {
  @override
  _ReviewState createState() => _ReviewState();

  Shop shop;
  Review({this.shop});
}

class _ReviewState extends State<Review> {
  int rating;
  String review = "";
  @override
  Widget build(BuildContext context) {
    return 
           Container(
            height: MediaQuery.of(context).size.height/3,
            child: Column(
              children:[
                Text('Rate the service of ',style: TextStyle(color: base,fontSize: 15.0),),
                RatingBar(
                  itemBuilder: (BuildContext context, int index){
                    return Icon(
                      Icons.star,
                      color: Colors.amber,
                    );},
                  itemCount: 5,
                  onRatingUpdate: (val){
                    rating = val.toInt();
                  },
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
                    child: TextFormField(
                    
                    decoration: InputDecoration(
                      hintText: "Provide your reviews here"
                    ),
                    onChanged: (val){
                      review = val;
                    },
                  ),
                ),
                FlatButton(
                  color: base,
                  onPressed: ()async{
                    submitReview(review, rating,widget.shop.shopId);
                    final InAppReview app = InAppReview.instance;
                    if(await app.isAvailable()){
                      app.openStoreListing();
                    }
                  }, 
                  child: Text("Rate BakeMyCake",style: TextStyle(color: white,fontWeight: FontWeight.bold),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(border),)
                )
                
              ]
            ),
          );
  }

  void submitReview(String review,int rating,String shopId) async{
    await DatabaseService().submitReview(shopId, review, rating);
  }
}