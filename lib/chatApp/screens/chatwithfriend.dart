import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bake2home/chatApp/firebaseServices/chatService.dart';
import 'package:bake2home/chatApp/screens/showimage.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/functions/order.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bubble/bubble.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class ChatWithFriend extends StatefulWidget {
  final Order order;
  ChatWithFriend({this.order});

  @override
  _ChatWithFriendState createState() => _ChatWithFriendState();
}

class _ChatWithFriendState extends State<ChatWithFriend> {
  bool seen = false;
  String msg = '';
  var val = 0.0;
  String uniqueid = '';
  TextEditingController tc = new TextEditingController();
  ScrollController sc;
  String myid;
  String fid;
  int seenmsg;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seen = true;
    sc = new ScrollController();
    uniqueid = this.widget.order.orderId;
    myid = this.widget.order.userId;
    fid = this.widget.order.shopId;
  }

  @override
  void dispose() {
    sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    seenmsg = 0;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                seen = false;
              });
              Navigator.pop(context);
            },
          ),
          title: Text(shopMap[fid].shopName),
          backgroundColor: base,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('myChats')
                      .doc(uniqueid)
                      .collection('messages')
                      .snapshots(),
                  builder: (context, ss) {
                    print(ss.runtimeType);
                    print(ss.data.runtimeType);
                    if (ss.hasData) {
                      return ListView.builder(
                          controller: sc,
                          itemCount: ss.data.docs.length,
                          itemBuilder: (context, i) {
                            Future.delayed(Duration(milliseconds: 100), () {
                              sc.animateTo(sc.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.ease);
                            });
                            Timestamp ts = ss.data.docs[i].data()['time'];
                            DateTime ds = ts.toDate();
                            String time = '';
                            if (ds.hour >= 00 && ds.hour < 12) {
                              if (ds.minute >= 10)
                                time = '${ds.hour}:${ds.minute} AM';
                              else
                                time = '${ds.hour}:0${ds.minute} AM';
                            } else {
                              if (ds.minute >= 10)
                                time = '${ds.hour}:${ds.minute} PM';
                              else
                                time = '${ds.hour}:0${ds.minute} PM';
                            }
                            return ss.data.docs[i].data()['type'] == 1
                                ? (ss.data.docs[i].data()['sender'] == myid
                                    ? sender(
                                        context,
                                        ss.data.docs[i].data()['message'],
                                        time,
                                        ss.data.docs[i].data()['seen'],
                                        ss.data.docs[i].data()['tms'],
                                      )
                                    : receiver(
                                        context,
                                        ss.data.docs[i].data()['message'],
                                        time,
                                        seen,
                                        ss.data.docs[i].data()['tms'],
                                      ))
                                : (ss.data.docs[i].data()['sender'] == myid
                                    ? senderimage(
                                        context,
                                        ss.data.docs[i].data()['imageurl'],
                                        ss.data.docs[i].data()['uploaded'],
                                        ss.data.docs[i].data()['tms'],
                                        ss.data.docs[i].data()['filename'],
                                        time,
                                        ss.data.docs[i].data()['path'],
                                      )
                                    : receiverimage(
                                        context,
                                        ss.data.docs[i].data()['imageurl'],
                                        ss.data.docs[i].data()['uploaded'],
                                        ss.data.docs[i].data()['tms'],
                                        ss.data.docs[i].data()['filename'],
                                        time,
                                        ss.data.docs[i].data()['path']));
                          });
                    } else {
                      return Center(
                        child: Text("Say hi"),
                      );
                    }
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                // color: Colors.pink,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: black,
                ),
              ),

              margin: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
//            color: Colors.grey,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      maxLines: null,
                      controller: tc,
                      onChanged: (val) {
                        setState(() {
                          msg = val;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 5.0),
                          hintText: "Send a message",
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    icon:
                        msg.length != 0 ? Icon(Icons.send) : Icon(Icons.photo),
                    onPressed: msg.length != 0
                        ? () {
                            Timestamp timestamp =
                                Timestamp.fromDate(DateTime.now());
                            String ts = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();
                            ChatService(uniqueid: uniqueid).sendMessage(
                                msg, myid, fid, timestamp, ts, false);
                            setState(() {
                              msg = '';
                              tc.clear();
                            });
                            Future.delayed(Duration(milliseconds: 100), () {
                              sc.animateTo(sc.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            });
                          }
                        : () {
                            getImage(context);
                            Future.delayed(Duration(milliseconds: 100), () {
                              sc.animateTo(sc.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            });
                          },
                  )
                ],
              ),
            )
          ],
        ));
  }

  sender(BuildContext context, String msg, String time, bool seen, String tms) {
    Color color = seen ? Colors.green : black;
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                child: Bubble(
                  nip: BubbleNip.rightBottom,
                  color: base,
                  radius: Radius.circular(20.0),
                  nipHeight: 8,
                  nipWidth: 10,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      children: <Widget>[
                        Text(
                          msg,
                          style: TextStyle(color: white),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.done_all,
                          color: color,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(
                  time,
                  style: TextStyle(fontSize: 10.0),
                ),
              )
            ],
          ),
          CircleAvatar(
            child: Icon(
              Icons.person_pin,
              size: 20,
            ),
            radius: 10,
          )
        ],
      ),
    );
  }

  receiver(
      BuildContext context, String msg, String time, bool seen, String tms) {
    if (seen) {
      ChatService(uniqueid: uniqueid).updateseen(tms);
    }
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            child: Icon(
              Icons.person_pin,
              size: 20,
            ),
            radius: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Bubble(
                  nip: BubbleNip.leftBottom,
                  color: Colors.grey.withOpacity(0.3),
                  radius: Radius.circular(20.0),
                  nipHeight: 8,
                  nipWidth: 10,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.65,
                    ),
                    child: Text(
                      msg,
                      style: TextStyle(color: white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  time,
                  style: TextStyle(fontSize: 10.0),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  senderimage(BuildContext context, String url, bool uploaded, String tms,
      String filename, String time, String path) {
    var width = MediaQuery.of(context).size.width * 0.70;
    File file = new File('$path');
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 10.0),
      width: width,
      child: uploaded
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: width,
                      width: width,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ShowImage(
                              hash: filename.hashCode.toString(),
                              url: url,
                              name: filename,
                            );
                          }));
                        },
                        child: Bubble(
                          nip: BubbleNip.rightBottom,
                          padding: BubbleEdges.all(5.0),
                          color: base,
                          radius: Radius.circular(5.0),
                          nipHeight: 10,
                          nipWidth: 10,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.fitWidth,
                                placeholder: (context, url) {
                                  return Container(
                                      child: Center(
                                          child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(base),
                                  )));
                                },
                                errorWidget: (context, url, error) {
                                  return Icon(Icons.error);
                                },
                              )),
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(fontSize: 10.0),
                    )
                  ],
                ),
                CircleAvatar(
                  child: Icon(
                    Icons.person_pin,
                    size: 20,
                  ),
                  radius: 10,
                )
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: width,
                          width: width,
                          child: Bubble(
                            nip: BubbleNip.rightBottom,
                            color: base,
                            padding: BubbleEdges.all(5.0),
                            radius: Radius.circular(5.0),
                            nipHeight: 10,
                            nipWidth: 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.file(
                                file,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: width,
                          width: width,
                          child: GestureDetector(
                            onTap: () {
                              ChatService(uniqueid: uniqueid).cancelupload(tms);
                            },
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Icon(
                                    Icons.clear,
                                    color: black,
                                    size: 20,
                                  ),
                                ),
                                Center(
                                  child: CircularProgressIndicator(
                                    value: val,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.6),
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(base),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      time,
                      style: TextStyle(fontSize: 10.0),
                    )
                  ],
                ),
                CircleAvatar(
                  child: Icon(
                    Icons.person_pin,
                    size: 20,
                  ),
                  radius: 10,
                )
              ],
            ),
    );
  }

  receiverimage(BuildContext context, String url, bool uploaded, String tms,
      String filename, String time, String path) {
    var width = MediaQuery.of(context).size.width * 0.70;
    return uploaded
        ? Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
            width: width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  child: Icon(
                    Icons.person_pin,
                    size: 20,
                  ),
                  radius: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: width,
                      width: width,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ShowImage(
                              hash: filename.hashCode.toString(),
                              url: url,
                              name: filename,
                            );
                          }));
                        },
                        child: Bubble(
                            nip: BubbleNip.leftBottom,
                            padding: BubbleEdges.all(5.0),
                            color: Colors.grey.withOpacity(0.3),
                            radius: Radius.circular(5.0),
                            nipHeight: 10,
                            nipWidth: 10,
                            child: CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.fitWidth,
                              placeholder: (context, url) {
                                return Container(
                                    child: Center(
                                        child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(base),
                                )));
                              },
                              errorWidget: (context, url, error) {
                                return Icon(Icons.error);
                              },
                            )),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(fontSize: 10.0),
                    )
                  ],
                ),
              ],
            ))
        : Container();
  }

  Future<void> getImage(BuildContext context) async {
    var file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      uploadphoto(file);
    }
  }

  Future<void> uploadphoto(File file) async {
    try {
      Timestamp ts = Timestamp.fromDate(DateTime.now());
      String tms = ts.millisecondsSinceEpoch.toString();
      String filename = basename(file.path);
      ChatService(uniqueid: uniqueid)
          .startUpload(myid, fid, ts, tms, filename, file.path);
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child(filename);
      StorageUploadTask uploadTask = storageReference.putFile(file);
      uploadTask.events.listen((event) {
        setState(() {
          val = event.snapshot.bytesTransferred / event.snapshot.totalByteCount;
          print('val is $val');
        });
      });
      StorageTaskSnapshot snapshot = await uploadTask.onComplete;
      String link = await snapshot.ref.getDownloadURL();
      ChatService(uniqueid: uniqueid).completeUpload1(link, tms);
      setState(() {
        val = 0.0;
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
