import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/MySliverAppBar.dart';
import 'package:bake2home/widgets/HomeTile.dart';
import 'package:bake2home/widgets/HomeHeading.dart';

class VendorProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                delegate: MySliverAppBar(expandedHeight: 350),
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: Container(
                    height: 150.0,
                    margin: EdgeInsets.fromLTRB(15.0, 350/6 + 15.0, 15.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width/4 + 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(border),
                            gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xffeaafc8),Color(0xff654ea3)]
                            )
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Experience',
                                  style: TextStyle(
                                    color: white,

                                  ),

                                ),
                                Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                      '2+\nyears',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold
                                      ),
                                      
                                  ),
                                    ),
                                ),

                              ]
                            ),
                          )
                        ),
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width/4 + 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(border),
                            gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xffeaafc8),Color(0xff654ea3)]
                            )
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Variety',
                                  style: TextStyle(
                                    color: white,

                                  ),

                                ),
                                Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                      '29+',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold
                                      ),
                                      
                                  ),
                                    ),
                                ),

                              ]
                            ),
                          )
                        ),
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width/4 + 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(border),
                            gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xffeaafc8),Color(0xff654ea3)]
                            )
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Orders',
                                  style: TextStyle(
                                    color: white,

                                  ),

                                ),
                                Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                      '1K+',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold
                                      ),
                                      
                                  ),
                                    ),
                                ),

                              ]
                            ),
                          )
                        ),

                      ]
                    )
                    
                )
              ),
              SliverToBoxAdapter(
                child:Homeheading(heading:'Recently Added'),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 150.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context,int index){
                      return Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width/4 + 5,
                        margin: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(border),
                            gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xffeaafc8),Color(0xff654ea3)]
                            )
                        ),
                        child:Stack(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width/4 + 5,
                              height: MediaQuery.of(context).size.width/4 + 5,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/cookie.jpeg"),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(border)
                              ),
                            ),
                            Container( 
                              margin: EdgeInsets.fromLTRB(0.0, MediaQuery.of(context).size.width/4 + 10, 0.0, 0),
                              alignment: Alignment.center,
                              child: Text(
                                "Red Velvet Cake",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: white,
                                )
                              ),
                            )
                          ],
                        )

                      );
                    }
                  )
                )
              ),
              SliverToBoxAdapter(
                child: Homeheading(heading: "Categories"),
              ),
              SliverToBoxAdapter(
                child: ListView.builder(
                  physics: ScrollPhysics(
                    parent: NeverScrollableScrollPhysics(),
                  ),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index){
                  return  Container(
                  margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                  height: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/cake.jpeg"),
                      fit: BoxFit.fill
                    ),
                    borderRadius: BorderRadius.circular(border)
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Cakes",
                    style: TextStyle(
                      color: white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                );
                  }
                )
              )
              
              
            
            ],
          ),
        )
      );
    
  }
}