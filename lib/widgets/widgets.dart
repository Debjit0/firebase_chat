import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    labelStyle: TextStyle(color: Colors.black),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFF50057), width: 2)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFF50057), width: 2),
    ),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFF50057), width: 2)));

void nextPage({Widget? page, BuildContext? context}) {
  Navigator.push(context!, MaterialPageRoute(builder: (_) => page!));
}

void nextPageOnly({Widget? page, BuildContext? context}) {
  Navigator.pushAndRemoveUntil(
      context!, MaterialPageRoute(builder: (_) => page!), (route) => false);
}
