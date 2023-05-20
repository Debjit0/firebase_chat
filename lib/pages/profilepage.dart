import 'package:firebase_chat/pages/homepage.dart';
import 'package:flutter/material.dart';

import '../helper/helperfunctions.dart';
import '../service/authprovider.dart';
import '../widgets/widgets.dart';
import 'loginpage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthProvider authProvider = AuthProvider();
  String userName = "";
  String email = "";

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Profile"),
        centerTitle: true,
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
              onTap: () {
                nextPageOnly(context: context, page: HomePage());
              },
              leading: Icon(Icons.group_outlined),
              title: Text("Groups"),
            ),
            ListTile(
              onTap: () {
                nextPageOnly(context: context, page: ProfilePage());
              },
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name", style: TextStyle(fontSize: 17)),
                Text(userName, style: const TextStyle(fontSize: 17)),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email", style: TextStyle(fontSize: 17)),
                Text(email, style: const TextStyle(fontSize: 17)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
