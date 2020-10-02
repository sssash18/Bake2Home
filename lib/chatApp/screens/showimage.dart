import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:bake2home/constants.dart';

class ShowImage extends StatefulWidget {
  final String hash;
  final String url;
  final String name;
  ShowImage({this.hash, this.url, this.name});
  @override
  _ShowImageState createState() =>
      _ShowImageState(url: url, hash: hash, name: name);
}

class _ShowImageState extends State<ShowImage> {
  final String url;
  final String hash;
  final String name;
  _ShowImageState({this.hash, this.url, this.name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: PhotoView(
          backgroundDecoration: BoxDecoration(color: white),
          imageProvider: NetworkImage(url),
          loadingBuilder: (context, event) {
            return event != null
                ? Center(
                    child: CircularProgressIndicator(
                      value: event.cumulativeBytesLoaded /
                          event.expectedTotalBytes,
                      valueColor: AlwaysStoppedAnimation<Color>(base),
                    ),
                  )
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
