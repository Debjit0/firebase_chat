import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/helper/helperfunctions.dart';
import 'package:firebase_chat/pages/loginpage.dart';
import 'package:firebase_chat/pages/profilepage.dart';
import 'package:firebase_chat/pages/searchpage.dart';
import 'package:firebase_chat/service/authprovider.dart';
import 'package:firebase_chat/service/databaseprovider.dart';
import 'package:firebase_chat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthProvider authProvider = AuthProvider();
  String userName = "";
  String email = "";
  Stream? groups;
  bool _isLoading = false;
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
        userName = value!;
      });
    });

    await HelperFunctions.getUserEmailfromSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    await DatabaseProvider(uid: uid).getUserGroups().then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Groups"),
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
            Text(userName),
            Divider(
              height: 50,
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              leading: Icon(Icons.group_outlined),
              title: Text("Groups"),
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
    );
  }

  groupList() {
    StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            return Container();
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  popUpDialog(BuildContext) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Create Group",
              textAlign: TextAlign.left,
            ),
            content: Column(
              children: [],
            ),
          );
        });
  }

  noGroupWidget() {
    return Container(
      child: Text("no group"),
    );
  }
}

//2:08
//updates
