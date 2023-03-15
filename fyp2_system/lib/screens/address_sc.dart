import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2_system/Login_Components/all_button.dart';
import 'package:fyp2_system/consts/firebase_consts.dart';
import 'package:fyp2_system/screens/account_sc.dart';
import 'package:fyp2_system/services/color_utils.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:fyp2_system/widgets/logintext_widget.dart';

class AddressSc extends StatefulWidget {
  const AddressSc({super.key});

  @override
  State<AddressSc> createState() => _AddressScState();
}

class _AddressScState extends State<AddressSc> {
  final _formKey = GlobalKey<FormState>();

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

  final addressline1controller = TextEditingController();
  final addressline2controller = TextEditingController();
  final zipcodecontroller = TextEditingController();
  final citycontroller = TextEditingController();

  @override
  void dispose() {
    addressline1controller.dispose();
    addressline2controller.dispose();
    zipcodecontroller.dispose();
    citycontroller.dispose();
    // mobilecontroller.dispose();
    super.dispose();
  }

  updateAddress() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: SpinKitFadingFour(color: Colors.black),
        );
      },
    );
    User? user = authInstance.currentUser;
    if (user == null) {
      GlobalMethods.BackDialog(
          title: 'Error',
          subtitle: 'Please Log In!',
          lastitle: 'Login Now',
          fct: () {},
          vicon: Icon(Icons.error),
          context: context);
      return;
    }
    try {
      final User? user = authInstance.currentUser;
      final _uid = user!.uid;
      await FirebaseFirestore.instance
          .collection('ShopUsers')
          .doc(_uid)
          .update({
        'address Line1': addressline1controller.text,
        'address Line2': addressline2controller.text,
        'zipcode': zipcodecontroller.text,
        'city': citycontroller.text,
        'state': valueChoose.toString(),
      });
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AccountSc(),
        ),
      );
      Fluttertoast.showToast(msg: 'Successfully Registered!');
    } catch (e) {
      GlobalMethods.errorDialog(
          subtitle: e.toString(),
          vicon: Icon(Icons.error_outline_outlined),
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: vTextWidget(
          text: 'Update Address',
          color: Colors.white,
          textSize: 24.0,
          isTitle: true,
          fontWeight: FontWeight.bold,
        ),
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () =>
              Navigator.canPop(context) ? Navigator.pop(context) : null,
          child: Icon(
            IconlyLight.arrowLeft2,
            color: Colors.white,
            size: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
                height: MediaQuery.of(context).size.height / 1.10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    hexStringToColor("7DCB2B93"),
                    hexStringToColor("7D9546C4"),
                    hexStringToColor("7D5E61F4"),
                  ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
                ),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 60),
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
                            ),
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    UpdateButton(
                      onTap: () {
                        updateAddress();
                      }, //updateaddress,
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
