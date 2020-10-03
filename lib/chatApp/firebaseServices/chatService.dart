import 'package:bake2home/constants.dart';
import 'package:bake2home/services/PushNotification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final String uniqueid;

  ChatService({this.uniqueid});

  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('myChats');

  sendMessage(String msg, String uid, String fid, Timestamp time, String tms,
      bool seen) async {
    try {
      await _collectionReference
          .doc(uniqueid)
          .collection('messages')
          .doc(tms)
          .set({
        'sender': uid,
        'receiver': fid,
        'message': msg,
        'type': 1,
        'time': time,
        'tms': tms,
        'seen': false,
      });
      await PushNotification()
          .pushMessage(shopMap[fid].shopName, msg, shopMap[fid].token);
    } catch (e) {
      print(e.toString());
    }
  }

  updateseen(String tms) async {
    try {
      return await _collectionReference
          .doc(uniqueid)
          .collection('messages')
          .doc(tms)
          .update({
        'seen': true,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  startUpload(String uid, String fid, Timestamp time, String tms,
      String filename, String path) async {
    try {
      await _collectionReference
          .doc(uniqueid)
          .collection('messages')
          .doc(tms)
          .set({
        'sender': uid,
        'receiver': fid,
        'tms': tms,
        'type': 2,
        'time': time,
        'uploaded': false,
        'imageurl': null,
        'filename': filename,
        'path': path
      });
      await PushNotification()
          .pushMessage(shopMap[fid].shopName, "Photo", shopMap[fid].token);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> completeUpload1(String url, String tms) async {
    try {
      return await _collectionReference
          .doc(uniqueid)
          .collection('messages')
          .doc(tms)
          .update({
        'uploaded': true,
        'imageurl': url,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> cancelupload(String tms) async {
    try {
      return await _collectionReference
          .doc(uniqueid)
          .collection('messages')
          .doc(tms)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
