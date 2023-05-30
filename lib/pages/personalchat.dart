import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/pages/profilepage.dart';
import 'package:firebase_chat/pages/searchpage.dart';
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

    await DatabaseProvider(uid: uid).getUserGroups().then((snapshot) {
      setState(() {
        //print("check");
        chats = snapshot;
      });
    });
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
              onTap: () {},
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
    );
  }
}


//work on get user `chats
