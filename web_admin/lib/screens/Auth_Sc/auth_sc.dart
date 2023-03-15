import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/screens/Auth_Sc/checkUser.dart';
import 'package:web_admin/screens/Auth_Sc/login_sc.dart';

class auth_Sc extends StatelessWidget {
  const auth_Sc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return checkUser();
          } else {
            // Fluttertoast.showToast(msg: "Unauthorised Access");
            return LoginSc();
          }
        },
      ),
    );
  }
}
