import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/pages/homepage.dart';
import 'package:firebase_chat/service/databaseprovider.dart';
import 'package:flutter/material.dart';

import '../helper/imagepicker.dart';
import '../widgets/widgets.dart';

class ChangeGroupPic extends StatefulWidget {
  final String groupId;
  const ChangeGroupPic({super.key, required this.groupId});

  @override
  State<ChangeGroupPic> createState() => _ChangeGroupPicState();
}

class _ChangeGroupPicState extends State<ChangeGroupPic> {
  String image = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Change Group Pic"),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (() {
              pickImage().then((value) {
                setState(() {
                  image = value;
                });
              });
            }),
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 10, 10, 10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: Color.fromARGB(255, 63, 63, 63),
                    size: 50,
                  ),
                  Text(
                    "Click Here To Select Photo",
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 63, 63, 63),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          image != ""
              ? ElevatedButton(
                  onPressed: () {
                    DatabaseProvider(
                            uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateGroupIcon(File(image), widget.groupId);
                  },
                  child: Text("Update"))
              : Container(),
        ],
      ),
    );
  }
}
