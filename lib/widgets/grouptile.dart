import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/pages/groupchatpage.dart';
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
  getGroupIcon() async {
    var collection = FirebaseFirestore.instance.collection('groups');
    var docSnapshot = await collection.doc(widget.groupId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        groupIcon = data?['groupicon'];
      });
      print(groupIcon);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupIcon();
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
                  radius: (30),
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      groupIcon,
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                    ),
                  ),
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
