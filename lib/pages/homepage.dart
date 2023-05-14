import 'package:firebase_chat/pages/loginpage.dart';
import 'package:firebase_chat/pages/searchpage.dart';
import 'package:firebase_chat/service/authprovider.dart';
import 'package:firebase_chat/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthProvider authProvider = AuthProvider();

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
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: [
            Icon(
              Icons.account_circle_rounded,
              size: 150,
              color: Colors.grey[70],
            )
          ],
        )),
        body: ElevatedButton(
            child: Text("Logout"),
            onPressed: () {
              authProvider.signout();
              nextPageOnly(context: context, page: LoginPage());
            }));
  }
}

//1:37
//updates
