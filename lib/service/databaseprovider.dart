import 'dart:ffi';
import 'dart:math';

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

  //creating group and storing in fb
  Future createGroup(String userName, String id, String groupName) async {
    final data = {
      "groupname": groupName,
      "groupicon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupid": "",
      "recentmessage": "",
      "recentmessagesender": ""
    };

    DocumentReference groupDocumentReference = await groupCollection.add(data);

    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupid": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  //getting chats
  Future getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  //getting group members
  Future getGroupMembers(String groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  //search by group name
  Future searchByGroupName(String groupName) async {
    return groupCollection.where("groupname", isEqualTo: groupName).get();
  }

  //check if the user is joined n the group
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    //testing
    //print("${groupId}_$groupName");
    //print(groups[2]);

    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  Future toggleGroupJoin(
      String groupId, String groupName, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update(
        {
          "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
        },
      );
      await groupDocumentReference.update(
        {
          "members": FieldValue.arrayRemove(["${uid}_$userName"])
        },
      );
    } else {
      await userDocumentReference.update(
        {
          "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
        },
      );
      await groupDocumentReference.update(
        {
          "members": FieldValue.arrayUnion(["${uid}_$userName"])
        },
      );
    }
  }
}
