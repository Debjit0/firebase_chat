import 'package:flutter/material.dart';

class PersonalChatPage extends StatefulWidget {
  final String chatName;
  const PersonalChatPage({super.key, required this.chatName});

  @override
  State<PersonalChatPage> createState() => _PersonalChatPageState();
}

class _PersonalChatPageState extends State<PersonalChatPage> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatName),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(children: [
        //chatMessages(),
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Message",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }

  sendMessage() {}
  chatMessages() {}
}
