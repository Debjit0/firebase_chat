import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/pages/registerpage.dart';
import 'package:firebase_chat/service/authprovider.dart';
import 'package:firebase_chat/service/databaseprovider.dart';
import 'package:firebase_chat/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';

import '../helper/helperfunctions.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;

  AuthProvider authProvider = AuthProvider();
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Chatify",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Login now see what they are chatting",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      SvgPicture.asset(
                        "assets/images/login.svg",
                        height: 200,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: "Email",
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        validator: (value) {
                          RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        validator: (value) {
                          (value!.length < 6)
                              ? "Password cant be less than 6"
                              : null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          child: Text(
                            "Login",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            login();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text.rich(
                          TextSpan(text: "Don't have an account? ", children: [
                        TextSpan(
                            text: "Register Here",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                nextPageOnly(
                                    page: RegisterPage(), context: context);
                              }),
                      ]))
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  login() {
    print(password);
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      authProvider
          .loginUserWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseProvider(
                  uid: FirebaseAuth.instance.currentUser!.uid)
              .getUserData(email);

          //doing all this to save values to SF
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmail(email);
          await HelperFunctions.saveUserName(snapshot.docs[0]["fullname"]);
          nextPageOnly(context: context, page: HomePage());
        } else {
          showAlert(context, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
