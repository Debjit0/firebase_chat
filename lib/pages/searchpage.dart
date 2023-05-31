import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/helper/helperfunctions.dart';
import 'package:firebase_chat/pages/personalchat.dart';
import 'package:firebase_chat/service/databaseprovider.dart';
import 'package:firebase_chat/widgets/grouptile.dart';
import 'package:firebase_chat/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? groupsearchSnapshot;
  QuerySnapshot? emailsearchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  String userId = "";
  User? user;
  bool isUserJoined = false;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserIdandName();
  }

  getUserIdandName() async {
    await HelperFunctions.getUserNamefromSF().then(
      (value) {
        setState(() {
          userName = value!;
        });
        user = FirebaseAuth.instance.currentUser;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Search"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search groups or email",
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                )
              : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() {
    if (searchController.text.isNotEmpty) {
      isLoading = true;
      DatabaseProvider().searchByGroupName(searchController.text).then(
        (snapshot) {
          setState(() {
            groupsearchSnapshot = snapshot;
            isLoading = false;
            hasUserSearched = true;
          });
        },
      );

      DatabaseProvider().searchByEmail(searchController.text).then(
        (snapshot) {
          setState(() {
            emailsearchSnapshot = snapshot;
            isLoading = false;
            hasUserSearched = true;
          });
        },
      );
    }
  }

  groupList() {
    return hasUserSearched
        ? Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: groupsearchSnapshot!.docs.length,
                itemBuilder: (context, index) {
                  return groupTile(
                      userName,
                      groupsearchSnapshot!.docs[index]["groupid"],
                      groupsearchSnapshot!.docs[index]["groupname"],
                      groupsearchSnapshot!.docs[index]["admin"]);
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: emailsearchSnapshot!.docs.length,
                itemBuilder: (context, index) {
                  return individualUserTile(
                      emailsearchSnapshot!.docs[index]["email"]);
                },
              ),
            ],
          )
        : Container(
            child: Text("No Search"),
          );
  }

  groupTile(String userName, String groupId, String groupName, String admin) {
    DatabaseProvider(uid: uid).isUserJoined(groupName, groupId, userName).then(
      (value) {
        setState(() {
          isUserJoined = value;
          //print(!isUserJoined);
        });
      },
    );

    return Column(
      children: [
        Text(groupName),
        Text(admin),
        InkWell(
          onTap: () {
            DatabaseProvider(uid: uid)
                .toggleGroupJoin(groupId, groupName, userName);

            if (isUserJoined) {
              setState(() {
                isUserJoined = !isUserJoined;
              });
            } else {
              setState(() {
                isUserJoined = !isUserJoined;
              });
            }
          },
          child: isUserJoined
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text(
                    "Joined",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text("Join Now",
                      style: TextStyle(color: Colors.white)),
                ),
        ),
      ],
    );
  }

  individualUserTile(String email) {
    return Column(
      children: [
        Text(email),
        InkWell(
          onTap: () {
            DatabaseProvider(uid: uid)
                .createChat(userName, uid, email)
                .whenComplete(() {
              nextPageOnly(page: PersonalChat(), context: context);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
              border: Border.all(color: Colors.white, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Text(
              "chat",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
