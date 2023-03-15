import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2_system/consts/firebase_consts.dart';
import 'package:fyp2_system/fetch_data.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  Future<void> _googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();

    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResults = await authInstance.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken));
          if (authResults.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection('ShopUsers')
                .doc(authResults.user!.uid)
                .set({
              'id': authResults.user!.uid,
              'profilePic': '',
              'name': authResults.user!.displayName,
              'email': authResults.user!.email,
              'address Line1': '',
              'address Line2': '',
              'zipcode': '',
              'city': '',
              'state': '',
              'userWish': [],
              'userCart': [],
              'createdAt': Timestamp.now(),
            });
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const fetchSc(),
            ),
          );
        } on FirebaseException catch (e) {
          GlobalMethods.errorDialog(
              subtitle: '${e}',
              vicon: Icon(Icons.warning_amber_sharp),
              context: context);
        } catch (e) {
          GlobalMethods.errorDialog(
              subtitle: '${e}',
              vicon: Icon(Icons.warning_amber_sharp),
              context: context);
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blue,
          child: InkWell(
            onTap: () {
              _googleSignIn(context);
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        )),
                    height: 50,
                    width: 50,
                    // color: Colors.white,
                    child: Image.asset(
                      'lib/assets/images/Google.png',
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  vTextWidget(
                    text: 'Sign-in with google',
                    color: Colors.white,
                    textSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
