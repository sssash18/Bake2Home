import 'package:bake2home/chatApp/firebaseServices/usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<ChatUser> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  ChatUser _userFromFirebase(User user) {
    return user != null ? ChatUser(uid: user.uid) : null;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future registerEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(result.user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signInEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(result.user);
    } catch (e) {
      print(e.toString());
    }
  }
}
