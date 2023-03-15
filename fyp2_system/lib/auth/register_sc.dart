import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2_system/Login_Components/image_tiles.dart';
import 'package:fyp2_system/Login_Components/all_button.dart';
import 'package:fyp2_system/consts/firebase_consts.dart';
import 'package:fyp2_system/fetch_data.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/widgets/logintext_widget.dart';
import 'package:fyp2_system/services/color_utils.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_sc.dart';

class RegisterSc extends StatefulWidget {
  static const String routeName = '\RegisterSc';
  const RegisterSc({super.key});

  @override
  State<RegisterSc> createState() => _RegisterScState();
}

class _RegisterScState extends State<RegisterSc> {
  String? valueChoose;
  List Statesv = [
    "Johor",
    "Kedah",
    "Kuala Lumpur",
    "Labuan",
    "Melaka",
    "Negeri Sembilan",
    "Pahang",
    "Penang",
    "Perak",
    "Perlis",
    "Putrajaya",
    "Sabah",
    "Sarawak",
    "Selangor",
    "Terengganu",
  ];

  final _formKey = GlobalKey<FormState>();

  final namecontroller = TextEditingController();
  final phcontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();
  final addressline1controller = TextEditingController();
  final addressline2controller = TextEditingController();
  final zipcodecontroller = TextEditingController();
  final citycontroller = TextEditingController();

  // final mobilecontroller = TextEditingController();
  var _obscureText = true;
  var _obscureText2 = true;

  @override
  void dispose() {
    namecontroller.dispose();
    phcontroller.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    confirmpasswordcontroller.dispose();
    addressline1controller.dispose();
    addressline2controller.dispose();
    zipcodecontroller.dispose();
    citycontroller.dispose();
    // mobilecontroller.dispose();
    super.dispose();
  }

  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String? imageURL;

  _pickImage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }

  void signUp() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (pickedFile == null) {
        Fluttertoast.showToast(msg: "Please Select an Image");
        return;
      }
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: SpinKitFadingFour(color: Colors.black),
          );
        },
      );
      try {
        await authInstance.createUserWithEmailAndPassword(
            email: emailcontroller.text.trim(),
            password: passwordcontroller.text.trim());

        final User? user = authInstance.currentUser;
        final _uid = user!.uid;
        user.updateDisplayName(namecontroller.text);
        user.reload();

        final file = File(pickedFile!.path!);

        final ref = FirebaseStorage.instance
            .ref()
            .child('ShopUsers')
            .child(DateTime.now().toString());
        await ref.putFile(file);
        imageURL = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('ShopUsers').doc(_uid).set({
          'id': _uid,
          'token': '',
          'profilePic': imageURL,
          'name': namecontroller.text,
          'email': emailcontroller.text,
          'address Line1': addressline1controller.text,
          'address Line2': addressline2controller.text,
          'zipcode': zipcodecontroller.text,
          'city': citycontroller.text,
          'state': valueChoose.toString(),
          'userWish': [],
          'userCart': [],
          'createdAt': Timestamp.now(),
        });
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const fetchSc(),
          ),
        );
        Fluttertoast.showToast(msg: 'Successfully Registered!');
      } on FirebaseException catch (e) {
        Navigator.pop(context);
        GlobalMethods.errorDialog(
            subtitle: '${e.message}',
            vicon: Icon(Icons.warning_amber_sharp),
            context: context);
      } catch (e) {
        Navigator.pop(context);
        GlobalMethods.errorDialog(
            subtitle: '${e}',
            vicon: Icon(Icons.warning_amber_sharp),
            context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 0.70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    hexStringToColor("7DCB2B93"),
                    hexStringToColor("7D9546C4"),
                    hexStringToColor("7D5E61F4"),
                  ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 85,
                            backgroundColor: Colors.grey.shade500,
                            child: ClipOval(
                                child: pickedFile != null
                                    ? Image.file(
                                        File(pickedFile!.path!),
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'lib/assets/images/profile.png',
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      )),
                          ),
                          Positioned(
                            bottom: 20.0,
                            right: 20.0,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => _bottomsheet()),
                                );
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 40.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      'Hello There',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 52,
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Text(
                      'Register below with your details!',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            LoginText(
                              //  controller: emailcontroller,
                              hint: 'Full Name',
                              obscureText: false,
                              icon: IconlyBold.profile,
                              textInputAction: TextInputAction.next,
                              controller: namecontroller,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This Field is missing";
                                } else {
                                  return null;
                                }
                              },
                            ), //username

                            const SizedBox(height: 10),
                            LoginText(
                              //  controller: emailcontroller,
                              hint: 'Email',
                              obscureText: false,
                              icon: IconlyBold.profile,
                              textInputAction: TextInputAction.next,
                              controller: emailcontroller,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This Field is missing";
                                }
                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return ("Please Enter a valid Email");
                                }
                                return null;
                              },
                            ), //Email
                            const SizedBox(height: 10),
                            LoginText(
                              hint: 'Address Line 1',
                              obscureText: false,
                              icon: CupertinoIcons.arrow_down_right,
                              textInputAction: TextInputAction.next,
                              controller: addressline1controller,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This Field is missing";
                                }
                                return null;
                              },
                            ), //address1
                            const SizedBox(height: 10),
                            LoginText(
                              hint: 'Address Line 2',
                              obscureText: false,
                              icon: CupertinoIcons.arrow_down_right,
                              textInputAction: TextInputAction.next,
                              controller: addressline2controller,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This Field is missing";
                                }
                                return null;
                              },
                            ), //address2
                            const SizedBox(height: 10),
                            LoginText(
                              hint: 'Zip Code',
                              obscureText: false,
                              icon: CupertinoIcons.archivebox,
                              textInputAction: TextInputAction.next,
                              controller: zipcodecontroller,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This Field is missing";
                                }
                                return null;
                              },
                            ), //zipcode

                            const SizedBox(height: 10),
                            LoginText(
                              hint: 'City',
                              obscureText: false,
                              icon: CupertinoIcons.arrow_down_right,
                              textInputAction: TextInputAction.next,
                              controller: citycontroller,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This Field is missing";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11.0),
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(11.0),
                                        borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0.7),
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(11.0),
                                      borderSide: BorderSide(
                                          color: Colors.white.withOpacity(0.7)),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.flag_circle,
                                      color: Colors.white70,
                                    ),
                                    hintText: 'Satate',
                                    hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.7)),
                                  ),
                                  dropdownColor: Colors.grey.shade800,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconDisabledColor:
                                      Colors.white.withOpacity(0.7),
                                  iconEnabledColor:
                                      Colors.white.withOpacity(0.5),
                                  isExpanded: true,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: "Brand-Bold",
                                  ),
                                  value: valueChoose,
                                  onChanged: (newValue) {
                                    setState(() {
                                      valueChoose = newValue as String?;
                                    });
                                  },
                                  items: Statesv.map(
                                    (valueItem) {
                                      return DropdownMenuItem(
                                        value: valueItem,
                                        child: Text(valueItem),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            LoginText(
                              hint: 'Phone Number',
                              obscureText: false,
                              icon: CupertinoIcons.phone_circle_fill,
                              textInputAction: TextInputAction.next,
                              controller: phcontroller,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This Field is missing";
                                }
                                if (value.length > 11 && value.length < 10) {
                                  return ("Please Enter a valid Phone Number");
                                }
                                return null;
                              },
                            ), //phnumber

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
                              textInputAction: TextInputAction.next,
                              controller: passwordcontroller,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                RegExp regex = RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  return "This Field is missing";
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("Please Enter Valid Password Min. 6 Characters");
                                }
                                return null;
                              },
                            ), //password

                            const SizedBox(height: 10),
                            LoginText(
                              //  controller: confirmpasswordcontroller,
                              hint: 'Confirm Password',
                              obscureText: _obscureText2,
                              icon: IconlyBold.lock,
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText2 = !_obscureText2;
                                    });
                                  },
                                  child: Icon(
                                      _obscureText2
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white)),
                              textInputAction: TextInputAction.done,
                              controller: confirmpasswordcontroller,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "This Field is missing";
                                }
                                if (confirmpasswordcontroller.text !=
                                    passwordcontroller.text) {
                                  return "Password did not match.";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ), // confirm password

                    const SizedBox(height: 20),

                    RegisButton(
                      onTap: () {
                        signUp();
                      }, //signUp,
                    ),

                    const SizedBox(height: 20),

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
                              'Or Continue With',
                              style: TextStyle(color: Colors.white),
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

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        //google button
                        But_Tiles(
                          image: AssetImage('lib/assets/images/Google.png'),
                          imagePath: 'lib/assets/images/Google.png',
                        ),

                        //   But_Tiles(imagePath: apple),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'I am a member! ',
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
                                        context, LoginSc.routeName);
                                  },
                                text: 'Login now',
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomsheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Your Profile Picture",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    _pickImage();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.image_search_rounded),
                  label: Text("Gallery")),
            ],
          ),
        ],
      ),
    );
  }
}
