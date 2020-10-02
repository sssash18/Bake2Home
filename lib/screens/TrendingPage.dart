import 'package:bake2home/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TrendingPage extends StatelessWidget {
  Widget showItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width / 1.4,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width / 1.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(border),
                    color: white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Text("Offered By",
                            style: TextStyle(color: Colors.grey[700])),
                        SizedBox(height: 5.0),
                        Text("The Dessert Town",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0)),
                        SizedBox(height: 5.0),
                        RatingBar(
                            initialRating: 3.2,
                            itemSize: 15.0,
                            ignoreGestures: true,
                            itemCount: 5,
                            glow: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Icon(
                                Icons.star,
                                color: Colors.amber,
                              );
                            },
                            onRatingUpdate: (rating) {})
                      ],
                    ),
                  )),
            ),
            Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: MediaQuery.of(context).size.height * 0.38,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(border),
                        topRight: Radius.circular(border),
                      ),
                      color: white,
                      image: DecorationImage(
                          image: AssetImage("assets/images/cake.jpeg"),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Chocolate Cake",
                        style: TextStyle(
                            color: white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Rs 400",
                        style: TextStyle(
                            color: white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trends in town "),
      ),
      // backgroundColor: Colors.green,
      // body: Container(
      //   child: Text("Hello", style: TextStyle(color: white)),
      // )

      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffeaafc8), Color(0xff654ea3)])),
        alignment: Alignment.center,
        child: CarouselSlider.builder(
            itemBuilder: (context, i) {
              return showItem(context);
            },
            itemCount: 5,
            options: CarouselOptions(
                enableInfiniteScroll: false,
                height: MediaQuery.of(context).size.height / 2)),
      ),
    );
  }
}
