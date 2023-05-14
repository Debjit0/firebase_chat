import 'package:firebase_chat/pages/loginpage.dart';
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
        appBar: AppBar(title: Text("HomePage")),
        body: ElevatedButton(
            child: Text("Logout"),
            onPressed: () {
              authProvider.signout();
              nextPageOnly(context: context, page: LoginPage());
            }));
  }
}
