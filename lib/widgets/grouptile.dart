import 'package:flutter/material.dart';

class GroupTitle extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTitle(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<GroupTitle> createState() => _GroupTitleState();
}

class _GroupTitleState extends State<GroupTitle> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.groupId),
      subtitle: Text(widget.groupName),
    );
  }
}
