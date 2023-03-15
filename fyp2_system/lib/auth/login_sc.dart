import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fyp2_system/Login_Components/all_button.dart';
import 'package:fyp2_system/Login_Components/google_button.dart';
import 'package:fyp2_system/auth/forget_pass.dart';
import 'package:fyp2_system/auth/register_sc.dart';
import 'package:fyp2_system/fetch_data.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/widgets/logintext_widget.dart';
import 'package:fyp2_system/services/color_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginSc extends StatefulWidget {
  static const String routeName = '\LoginSc';
  const LoginSc({super.key});

  @override
  State<LoginSc> createState() => _LoginScState();
}

class _LoginScState extends State<LoginSc> {
  //text controller
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final passFucosNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    passFucosNode.dispose();
    super.dispose();
  }

  //sing in user method
  Future signIn() async {
    //loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: SpinKitFadingFour(color: Colors.black),
        );
      },
    );

    //sign in email and pass
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );

      //loading circle stop
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const fetchSc(),
        ),
      );
      Fluttertoast.showToast(msg: 'Successfully Logged In!');
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height / 1.049,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  hexStringToColor("#7DCB2B93"),
                  hexStringToColor("#7D9546C4"),
                  hexStringToColor("#7D5E61F4"),
                ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Image(
                    image: AssetImage('lib/assets/images/Logoxbg.png'),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Welcome back, you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        LoginText(
                          hint: 'Email',
                          obscureText: false,
                          icon: IconlyBold.profile,
                          textInputAction: TextInputAction.next,
                          controller: emailcontroller,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This Field is missing";
                            } else {
                              return null;
                            }
                          },
                        ),
                        //email

                        const SizedBox(height: 10),

                        LoginText(
                          //   controller: passwordcontroller,
                          hint: 'Password',
                          obscureText: _obscureText,
                          icon: IconlyBold.lock,
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white)),
                          textInputAction: TextInputAction.done,
                          controller: passwordcontroller,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "This Field is missing";
                            } else {
                              return null;
                            }
                          },
                        ), //password
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {
                              GlobalMethods.navigateTo(
                                  ctx: context,
                                  routeName: ForgetPasswordScreen.routeName);
                            },
                            child: const Text(
                              'Forget password?',
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  LoginButton(
                    titlev: 'Sign In',
                    onTap: signIn,
                  ),
                  const SizedBox(height: 15),
                  GoogleButton(),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'OR CONTINUE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.8,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  LoginButton(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const fetchSc(),
                          ),
                        );
                      },
                      titlev: 'As a Guest'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Haven\'t Register? ',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'brand-bold',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, RegisterSc.routeName);
                                },
                              text: 'Register now',
                              style: TextStyle(
                                color: Colors.cyan[500],
                                fontFamily: 'brand-bold',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
