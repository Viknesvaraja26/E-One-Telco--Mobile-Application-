import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_admin/screens/Auth_Sc/login_sc.dart';
import 'package:web_admin/screens/main_screen.dart';

class checkUser extends StatefulWidget {
  const checkUser({Key? key}) : super(key: key);

  @override
  State<checkUser> createState() => _checkUserState();
}

class _checkUserState extends State<checkUser> {
  String role = 'user';
  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser!;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    if (snap.exists) {
      setState(() {
        role = snap['role'];
      });
    }
    if (role == 'Admin') {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MainScreen();
      })).then((value) => setState(
            () {},
          ));
      Fluttertoast.showToast(msg: "Welcome Admin");
    } else {
      navigateNext(LoginSc());
      Fluttertoast.showToast(msg: "Unauthorised Access");
    }
  }

  void navigateNext(Widget route) {
    Timer(Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => route));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
            child: const CircularProgressIndicator(),
          ),
          color: Colors.white),
    );
  }
}
