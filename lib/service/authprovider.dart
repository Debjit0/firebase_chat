import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/helper/helperfunctions.dart';
import 'package:firebase_chat/service/databaseprovider.dart';
import 'package:firebase_chat/widgets/widgets.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthProvider {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future loginUserWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (User != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e;
    }
  }

  Future registerUserWithEmailAndPassword(
      String fullname, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (User != null) {
        await DatabaseProvider(uid: user.uid).saveUserData(fullname, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e;
    }
  }

  signout() async {
    try {
      //signout
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmail("");
      await HelperFunctions.saveUserName("");
      firebaseAuth.signOut();
    } catch (e) {
      //
      return null;
    }
  }
}
