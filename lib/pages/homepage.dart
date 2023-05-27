import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/helper/helperfunctions.dart';
import 'package:firebase_chat/pages/loginpage.dart';
import 'package:firebase_chat/pages/profilepage.dart';
import 'package:firebase_chat/pages/searchpage.dart';
import 'package:firebase_chat/service/authprovider.dart';
import 'package:firebase_chat/service/databaseprovider.dart';
import 'package:firebase_chat/widgets/grouptile.dart';
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
        groups = snapshot;
      });
    });
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        //fb check
        if (snapshot.hasData) {
          //
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int revIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTitle(
                      groupIcon: snapshot.data['group'][revIndex],
                      groupId: getId(snapshot.data['groups'][revIndex]),
                      groupName: getName(snapshot.data['groups'][revIndex]),
                      userName: snapshot.data['fullname']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return CircularProgressIndicator();
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
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor),
                      )
                    : TextField(
                        onChanged: (val) {
                          setState(() {
                            groupName = val;
                          });
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(20)),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(20))),
                      ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )),
              TextButton(
                  onPressed: () {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseProvider(uid: uid)
                          .createGroup(userName, uid, groupName)
                          .whenComplete(() {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: Text(
                    "Create",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ))
            ],
          );
        });
  }

  noGroupWidget() {
    return Container(
      child: Text("no group"),
    );
  }
}

//2:32
//updates
