import 'package:bake2home/widgets/dropdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';

class ItemPage extends StatefulWidget {

  final Map item;
  ItemPage({this.item});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  String _price = '100';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
          CustomScrollView(
              slivers:<Widget>[ 
              SliverToBoxAdapter(
                              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[ 
                Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2.8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff654ea3),Color(0xffeaafc8)],
                )
                ),
                
                child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                            Colors.black.withOpacity(1.0),
                            Colors.black.withOpacity(1.0), 
                            Colors.black.withOpacity(0.1), 
                            Colors.transparent // <-- you might need this if you want full transparency at the edge
                    ],
                    stops: [0.0, 0.5,0.65, 1.0], //<-- the gradient is interpolated, and these are where the colors above go into effect (that's why there are two colors repeated)
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, 1.5*rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: CachedNetworkImage(
                          imageUrl: widget.item['photoUrl'],
                          fit: BoxFit.fill,                          
                        ),
                  ),
              ),
                Positioned(
                    top: MediaQuery.of(context).size.height/2.8 - MediaQuery.of(context).size.height/16,
                    left: (MediaQuery.of(context).size.width - MediaQuery.of(context).size.width/1.3)/2,
                    child: Container( 
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: white,
                      boxShadow: [BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 16.0,    
                    )],
                    ),
                    height: MediaQuery.of(context).size.height/8,
                    width : MediaQuery.of(context).size.width/1.3,
                    child: Text(widget.item['itemName'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),),
                  ),
                ),
                
            ]
            ),
            ),
            SliverToBoxAdapter(
              child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffeaafc8),Color(0xff654ea3)],
              )
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 6.0
                    )]
                    ),
                    margin: EdgeInsets.fromLTRB(15.0, MediaQuery.of(context).size.height/16 + 30, 15.0, 0),
                    child: Container(
                      height: MediaQuery.of(context).size.height/14,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          createDropDown(widget.item),
                          FlatButton.icon(
                            label: Text("Add to cart (Rs ${_price})"),
                            icon: Icon(Icons.add_shopping_cart),
                            onPressed: (){},
                          )
                        ]
                      ),
                    )
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 6.0
                    )]
                    ),
                    margin: EdgeInsets.fromLTRB(15.0, 30, 15.0, 0),
                    child: Container(
                      height: MediaQuery.of(context).size.height/14,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(border),
                      ),
                      child: Row(
                        children: <Widget>[
                         
                        ]
                      ),
                    )
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 16.0
                    )],
                    ),
                    margin: EdgeInsets.fromLTRB(15.0, 30, 15.0, 0),
                    child: Container(
                      height: MediaQuery.of(context).size.height/14,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(border),
                      ),
                    )
                  ),
                  Container( 
                    margin: EdgeInsets.fromLTRB(15.0, 45.0, 0, 0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Ingredients",
                      style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: head2,
                      )
                    )
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15.0, 15.0, 0, 0),
                    child: ListView.builder(
                      physics: ScrollPhysics(
                        parent: NeverScrollableScrollPhysics(),
                      ),
                      shrinkWrap: true,
                      itemCount: widget.item['ingredients'].keys.length,
                      itemBuilder: (BuildContext context, int index){
                        return Text(
                          '${widget.item['ingredients'].keys.elementAt(index)} - ${widget.item['ingredients'][widget.item['ingredients'].keys.elementAt(index)]}',
                          style: TextStyle(
                            color: white,
                            fontSize: textSize,
                          )
                        );
                      }
                    ),
                  ),
                  Container( 
                    margin: EdgeInsets.fromLTRB(15.0, 45.0, 15.0, 0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Description",
                      style: TextStyle(
                        color: white,
                        fontWeight: FontWeight.bold,
                        fontSize: head2,
                      )
                    )
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                    child: Text(
                      widget.item['recipe'],
                      style: TextStyle(
                        color: white,
                        fontSize: textSize
                      ),
                    )
                  ),
                ],
              ),                    
                
              
                )
            ),
            
            
            
            ],
          ) ,
          
      ),
    );
  }
  Widget createDropDown(Map item){
    List<String> itemList = [];
    item['variants'].keys.forEach(
      (value){
        itemList.add("${item['variants'][value]['size']} pound");
      }
    );

    String dropDownval = itemList[0];
    return DropdownButton(
      value: dropDownval,
      iconSize: 24,
    elevation: 16,
    style: TextStyle(color: base),
    underline: Container(
      height: 2,
      color: Colors.deepPurpleAccent,
    ),
    
      onChanged: (String newvalue){
        setState(() {
          dropDownval = newvalue;
        });
      },
      items: itemList.map<DropdownMenuItem<String>>((value){
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}