//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:fyp2_system/screens/bottombutt_sc.dart';
//import 'package:fyp2_system/screens/register_sc.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> signUpUsers(String email, String fullName, String phoneNumber,
      String password) async {
    String res = 'some error occured';

    try {
      if (email.isNotEmpty &&
          fullName.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          password.isNotEmpty) {
        //create users

        //UserCredential cred =
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      } else {
        res = 'All fields must not be empty';
      }
    } catch (e) {}

    return res;
  }
}

/*class AuthSc extends StatelessWidget {
  const AuthSc({super.key});
  static String id = 'authsc';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainSc();
          } else {
            return RegisterSc();
          }
        });
  }
}*/
