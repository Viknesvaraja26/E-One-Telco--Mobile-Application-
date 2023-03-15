import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:web_admin/screens/Auth_Sc/auth_sc.dart';

class LoginSc extends StatefulWidget {
  const LoginSc({super.key});

  @override
  State<LoginSc> createState() => _LoginScState();
}

class _LoginScState extends State<LoginSc> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future Loginv(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        await _auth
            .signInWithEmailAndPassword(
              email: email,
              password: password,
            )
            .then(
              (uid) => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => auth_Sc())),
            );
        Navigator.pop(context); //loading circle stop
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context); //loading circle stop
        //WRONG EMAIL
        if (e.code == 'user-not-found') {
          buildErrormessage("User not found\n Please try again..");
        }

        //INVALID EMAIL
        if (e.code == 'invalid-email') {
          buildErrormessage("Invalid Email\n Please try again..");
        }

        if (e.code == "permission-denied") {
          buildErrormessage("You access is denied\n Only Admin Can Access");
        }

        if (e.code == "network-request-failed") {
          buildErrormessage("You must have an active internet for Login.");
        }

        //WRONG PASSWORD
        else if (e.code == 'wrong-password') {
          buildErrormessage("Incorrect Password\n Please try again..");
        }
      }
    }
  }

  void buildErrormessage(String text) {
    final snackBar = SnackBar(
      backgroundColor: Colors.white.withOpacity(0.5),
      content: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // @override
  //void dispose() {
  // email.dispose();
  //pass.dispose();

  // super.dispose();
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8A2387),
                Color(0xFFE94057),
                Color(0xFFF27121),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Image(
                  image: AssetImage('lib/assets/images/Logo_xbg.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'One Store Telco Admin',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 380,
                  width: 325,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Welcome!',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Please Login to your Account',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 250,
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              suffixIcon: Icon(
                                FontAwesomeIcons.envelope,
                                size: 17,
                              ),
                            ),
                            validator: validateEmail,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 250,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: Icon(
                                FontAwesomeIcons.eyeSlash,
                                size: 17,
                              ),
                            ),
                            validator: validatePass,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent),
                              shadowColor:
                                  MaterialStatePropertyAll(Colors.transparent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ))),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Loginv(emailController.text,
                                  passwordController.text);
                            } else {
                              print('invalid');
                            }
                            // GlobalMethods.navigateTo(
                            //ctx: context, routeName: MainScreen.routeName);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF8A2387),
                                  Color(0xFFE94057),
                                  Color(0xFFF27121),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? email) {
    if (email!.isEmpty) {
      return 'Please input an Email';
    } else {
      return null;
    }
  }

  String? validatePass(String? password) {
    if (password!.isEmpty) {
      return 'Please input a Password';
    } else {
      return null;
    }
  }
}
