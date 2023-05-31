import 'package:firebase_chat/pages/personalchatpage.dart';
import 'package:firebase_chat/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatefulWidget {
  final String chatName;
  final String chatId;

  const ChatTile({super.key, required this.chatName, required this.chatId});

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        nextPage(
            page: PersonalChatPage(
              chatName: widget.chatName,
            ),
            context: context);
      },
      child: Container(
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.chatName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(widget.chatName),
          subtitle: Text(widget.chatId),
        ),
      ),
    );
  }
}
