import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/pages/homepage.dart';
import 'package:firebase_chat/pages/profilepage.dart';
import 'package:firebase_chat/pages/searchpage.dart';
import 'package:firebase_chat/widgets/chattile.dart';
import 'package:flutter/material.dart';

import '../helper/helperfunctions.dart';
import '../service/authprovider.dart';
import '../service/databaseprovider.dart';
import '../widgets/widgets.dart';
import 'loginpage.dart';

class PersonalChat extends StatefulWidget {
  const PersonalChat({super.key});

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  AuthProvider authProvider = AuthProvider();
  String userName = "";
  String email = "";
  Stream? chats;
  bool _isLoading = false;
  String groupName = "";
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserNamefromSF().then((value) {
      setState(() {
        //print("check");
        userName = value!;
      });
    });

    await HelperFunctions.getUserEmailfromSF().then((value) {
      setState(() {
        //print("check");
        email = value!;
      });
    });

    await DatabaseProvider(uid: uid).getUserChats().then(
      (snapshots) {
        setState(() {
          chats = snapshots;
          print(chats);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Chats "),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                nextPage(context: context, page: SearchPage());
              },
              icon: Icon(Icons.search_outlined))
        ],
      ),
      drawer: SafeArea(
        child: Drawer(
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: [
            Icon(
              Icons.account_circle_rounded,
              size: 150,
              color: Colors.grey[70],
            ),
            SizedBox(
              height: 15,
            ),
            //Text(userName),
            Divider(
              height: 50,
            ),
            ListTile(
              onTap: () {
                nextPageOnly(page: HomePage(), context: context);
              },
              leading: Icon(Icons.group_outlined),
              title: Text("Groups"),
            ),
            ListTile(
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              onTap: () {
                nextPage(context: context, page: PersonalChat());
              },
              leading: Icon(Icons.message_outlined),
              title: Text("Chats"),
            ),
            ListTile(
              onTap: () {
                nextPageOnly(context: context, page: ProfilePage());
              },
              leading: Icon(Icons.account_circle_outlined),
              title: Text("Profile"),
            ),
            ListTile(
              onTap: () {
                authProvider.signout();
                nextPageOnly(context: context, page: LoginPage());
              },
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
            ),
          ],
        )),
      ),
      body: chatList(),
    );
  }

  chatList() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data["perschats"] != null) {
            if (snapshot.data["perschats"].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['perschats'].length,
                itemBuilder: (context, index) {
                  int revIndex = snapshot.data['perschats'].length - index - 1;
                  return ChatTile(
                    chatName: snapshot.data["perschats"][revIndex],
                    chatId: "awdawd",
                  );
                },
              );
            } else {
              return Center(
                child: Text("No Chats"),
              );
            }
          } else {
            return Center(
              child: Text("No Data"),
            );
          }
        } else {
          return Text("No Data");
        }
      },
    );
    //return Text("test");
  }
}


//work on get user `chats
