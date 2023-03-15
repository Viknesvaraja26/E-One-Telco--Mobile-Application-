import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2_system/Login_Components/all_button.dart';
import 'package:fyp2_system/consts/firebase_consts.dart';
import 'package:fyp2_system/services/color_utils.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:fyp2_system/widgets/back_widget.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgetPasswordSc';
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailTextController = TextEditingController();
  // bool _isLoading = false;
  @override
  void dispose() {
    _emailTextController.dispose();

    super.dispose();
  }

  void _forgetPassFCT() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: SpinKitFadingFour(color: Colors.black),
        );
      },
    );

    if (_emailTextController.text.isEmpty ||
        !_emailTextController.text.contains("@")) {
      Navigator.pop(context);
      GlobalMethods.errorDialog(
          subtitle: "Incorrect Email. Please Input a valid Email.",
          vicon: Icon(Icons.error_outline),
          context: context);
    } else {
      try {
        await authInstance.sendPasswordResetEmail(
            email: _emailTextController.text.trim());
        Navigator.pop(context);
        GlobalMethods.passDialog(
            subtitle: "Please check your Email for Reset Password Link.",
            vicon: Icon(Icons.person),
            context: context);
      } on FirebaseAuthException catch (e) {
        //loading circle stop
        Navigator.pop(context);

        //WRONG EMAIL
        if (e.code == 'user-not-found') {
          buildErrormessage("User not found\n Please try again..");
        }

        //INVALID EMAIL
        if (e.code == 'invalid-email') {
          buildErrormessage("Invalid Email\n Please try again..");
        }

        //WRONG PASSWORD
        else if (e.code == 'wrong-password') {
          buildErrormessage("Incorrect Password\n Please try again..");
        }
      }
    }
  }

  void buildErrormessage(String text) {
    Fluttertoast.showToast(
        msg: text,
        timeInSecForIosWeb: 2,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
        fontSize: 14);
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      // backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("#7DCB2B93"),
                hexStringToColor("#7D9546C4"),
                hexStringToColor("#7D5E61F4"),
              ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                const BackWidget(),
                const SizedBox(
                  height: 20,
                ),
                vTextWidget(
                  text: 'Forget password',
                  color: Colors.white,
                  textSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _emailTextController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Email address',
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                LoginButton(
                  titlev: 'Reset now',
                  onTap: () {
                    _forgetPassFCT();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
