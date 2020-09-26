import 'package:bake2home/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TrendingPage extends StatelessWidget {
  Widget showItem(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height / 1.2,
      child: Stack(children: <Widget>[
        Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width / 1.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(border),
                  color: white,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              child: Text("Offered By",
                                  style: TextStyle(color: Colors.grey[700]))),
                          SizedBox(height: 10.0),
                          Container(
                              alignment: Alignment.center,
                              child: Text("The Dessert Town",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0))),
                          SizedBox(height: 10.0),
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
                    )
                  ],
                )),
            Positioned(
              left: (MediaQuery.of(context).size.width / 1.2 -
                      MediaQuery.of(context).size.width / 1.4) /
                  2,
              width: MediaQuery.of(context).size.width / 1.4,
              height: MediaQuery.of(context).size.height / 2.2,
              bottom: MediaQuery.of(context).size.height / 6,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: MediaQuery.of(context).size.height / 2.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(border),
                        color: white,
                        image: DecorationImage(
                            image: AssetImage("assets/images/cake.jpeg"),
                            fit: BoxFit.cover)),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    child: Text(
                      "Chocolate Cake\nRs 400",
                      style: TextStyle(
                          color: white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ]),
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
        child: Center(
          child: CarouselSlider.builder(
              itemBuilder: (context, i) {
                return showItem(context);
              },
              itemCount: 5,
              options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: MediaQuery.of(context).size.height / 2)),
        ),
      ),
    );
  }
}
