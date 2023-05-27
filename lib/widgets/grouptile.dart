import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/pages/chatpage.dart';
import 'package:firebase_chat/widgets/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class GroupTitle extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  //final String groupIcon;
  const GroupTitle({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
    //required this.groupIcon
  }) : super(key: key);

  @override
  State<GroupTitle> createState() => _GroupTitleState();
}

class _GroupTitleState extends State<GroupTitle> {
  String groupIcon = "";
  getGroupIcon() {
    Stream ds = FirebaseFirestore.instance
        .collection("groups")
        .doc(widget.groupId)
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextPage(
            context: context,
            page: ChatPage(
                groupId: widget.groupId,
                groupName: widget.groupName,
                userName: widget.userName));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: groupIcon == ""
              ? CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    widget.groupName.substring(0, 1).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                )
              : CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(groupIcon),
                ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Join the conversation as ${widget.userName}",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
