import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseProvider {
  final String? uid;
  DatabaseProvider({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  //save user data
  Future saveUserData(String fullname, String email) async {
    final data = {
      "fullname": fullname,
      "email": email,
      "groups": [],
      "profilepic": "",
      "uid": uid
    };
    await userCollection.doc(uid).set(data);
  }

  //get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //getting all the groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }
}
