import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2_system/auth/forget_pass.dart';
import 'package:fyp2_system/consts/firebase_consts.dart';
import 'package:fyp2_system/providers/cart_provider.dart';
import 'package:fyp2_system/providers/order_provider.dart';
import 'package:fyp2_system/providers/wishlist_provider.dart';
import 'package:fyp2_system/screens/address_sc.dart';
import 'package:fyp2_system/auth/login_sc.dart';
import 'package:fyp2_system/providers/dark_theme_provider.dart';
import 'package:fyp2_system/screens/orders/orders_sc.dart';
import 'package:fyp2_system/screens/viewed_recently/viewed_recently.dart';
import 'package:fyp2_system/screens/whishlist/whishtlist_sc.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';

import 'package:provider/provider.dart';

class AccountSc extends StatefulWidget {
  static const routeName = '/AccountSc';
  const AccountSc({Key? key}) : super(key: key);

  @override
  State<AccountSc> createState() => _AccountScState();
}

class _AccountScState extends State<AccountSc> {
  final User? user = authInstance.currentUser;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  String? _email;
  String? _name;
  String? _imgurl;
  String? _address;

  Future<void> getUserData() async {
    setState(() {
      SpinKitFadingFour(color: Colors.purple);
    });
    if (user == null) {
      setState(() {
        SpinKitFadingFour(color: Colors.purple);
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('ShopUsers')
          .doc(_uid)
          .get();
      if (userDoc == false) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        _imgurl = userDoc.get('profilePic');
        _address = userDoc.get('city');
      }
    } catch (e) {
      setState(() {
        SpinKitFadingFour(color: Colors.purple);
        Navigator.pop(context);
        GlobalMethods.errorDialog(
            subtitle: '${e}', vicon: Icon(Icons.error), context: context);
      });
    } finally {
      setState(() {
        SpinKitFadingFour(color: Colors.purple);
      });
    }
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

  updateImage() async {
    if (pickedFile == null) {
      Fluttertoast.showToast(msg: "Please Select an Image");
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: SpinKitFadingFour(color: Colors.purple),
        );
      },
    );
    try {
      final User? user = authInstance.currentUser;
      final _uid = user!.uid;
      final file = File(pickedFile!.path!);

      final ref = FirebaseStorage.instance
          .ref()
          .child('ShopUsers')
          .child(DateTime.now().toString());
      await ref.putFile(file);
      imageURL = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('ShopUsers')
          .doc(_uid)
          .update({
        'profilePic': imageURL,
      });
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AccountSc(),
        ),
      );
      Fluttertoast.showToast(msg: 'Successfully Uploaded!');
    } catch (e) {
      GlobalMethods.errorDialog(
          subtitle: e.toString(),
          vicon: Icon(Icons.error_outline_outlined),
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 2, 0, 0),
                    child: RichText(
                      text: TextSpan(
                        text: 'Hi, ',
                        style: const TextStyle(
                            color: Colors.purple,
                            fontSize: 27,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                            text: _name == null ? 'user' : _name,
                            style: TextStyle(
                              color: color,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: vTextWidget(
                      text: _email == null ? 'email' : _email.toString(),
                      color: color,
                      textSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                pickedFile = null;
                                              });
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red),
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              updateImage();
                                            },
                                            child: Text(
                                              'Update',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.blue),
                                            )),
                                      ],
                                      title: Text(
                                          'Update Image \n\n*Click on the image below to preview\n\t\tafter selecting an image*'),
                                      content: StatefulBuilder(builder:
                                          (BuildContext context, setState) {
                                        return SizedBox(
                                          height: 300,
                                          child: Stack(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {});
                                                },
                                                child: ClipOval(
                                                    child: _imgurl != null &&
                                                            pickedFile == null
                                                        ? Image.network(
                                                            _imgurl.toString(),
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.file(
                                                            File(pickedFile!
                                                                .path!),
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            fit: BoxFit.cover,
                                                          )),
                                              ),
                                              Positioned(
                                                bottom: 10.0,
                                                right: 10.0,
                                                child: InkWell(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: ((builder) =>
                                                            _bottomsheetUpdate()));

                                                    /*setState(() {
                                                      Future.delayed(Duration(
                                                        seconds: 15,
                                                      )).then((value) {
                                                        setState(() {});
                                                      });
                                                    });*/
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
                                        );
                                      }));
                                });
                          },
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.grey.shade500,
                            child: ClipOval(
                              child: _imgurl == null
                                  ? Image.asset('lib/assets/images/profile.png')
                                  : Image.network(
                                      _imgurl!,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _listTiles(
                      title: 'Address',
                      subtitle: _address == null ? 'My Address' : _address,
                      icon: IconlyLight.profile,
                      color: color,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AddressSc();
                        }));
                        User? user = authInstance.currentUser;
                        if (user == null) {
                          GlobalMethods.LoginDialog(
                              title: 'Alert',
                              subtitle: 'Please Log in 😅',
                              lastitle: 'Login Now',
                              fct: () {},
                              vicon: Icon(Icons.error),
                              context: context);
                          return;
                        }
                      }),
                  _listTiles(
                      title: 'Orders',
                      icon: IconlyLight.bag,
                      color: color,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: OrdersSc.routeName);

                        User? user = authInstance.currentUser;
                        if (user == null) {
                          GlobalMethods.LoginDialog(
                              title: 'Alert',
                              subtitle: 'Please Log in 😅',
                              lastitle: 'Login Now',
                              fct: () {},
                              vicon: Icon(Icons.error),
                              context: context);
                          return;
                        }
                      }),
                  _listTiles(
                      title: 'Wishlist',
                      icon: IconlyLight.heart,
                      color: color,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: WishlistSc.routeName);

                        User? user = authInstance.currentUser;
                        if (user == null) {
                          GlobalMethods.LoginDialog(
                              title: 'Alert',
                              subtitle: 'Please Log in 😅',
                              lastitle: 'Login Now',
                              fct: () {},
                              vicon: Icon(Icons.error),
                              context: context);
                          return;
                        }
                      }),
                  _listTiles(
                      title: 'Viewed',
                      icon: IconlyLight.show,
                      color: color,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: ViewedRecentlySc.routeName);

                        User? user = authInstance.currentUser;
                        if (user == null) {
                          GlobalMethods.LoginDialog(
                              title: 'Alert',
                              subtitle: 'Please Log in 😅',
                              lastitle: 'Login Now',
                              fct: () {},
                              vicon: Icon(Icons.error),
                              context: context);
                          return;
                        }
                      }),
                  _listTiles(
                      title: 'Forget password',
                      icon: IconlyLight.unlock,
                      color: color,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: ForgetPasswordScreen.routeName);
                      }),
                  SwitchListTile(
                    title: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
                      child: vTextWidget(
                        text: themeState.getDarkTheme
                            ? 'Dark mode'
                            : 'Light mode',
                        color: color,
                        textSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    secondary: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Icon(themeState.getDarkTheme
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined),
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        themeState.setDarkTheme = value;
                      });
                    },
                    value: themeState.getDarkTheme,
                  ),
                  _listTiles(
                    title: user == null ? 'LogIn' : 'LogOut',
                    icon: user == null ? IconlyLight.login : IconlyLight.logout,
                    color: color,
                    onPressed: () {
                      if (user == null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginSc(),
                          ),
                        );
                        return;
                      } else {
                        GlobalMethods.warningDialog(
                            title: 'Sign Out',
                            subtitle: 'Do you want to Log Out?',
                            lastitle: 'Log Out',
                            vicon: Icon(IconlyBold.profile),
                            fct: () async {
                              await authInstance.signOut();
                              ordersProvider.clearLocalOrders();
                              cartProvider.clearLocalCart();
                              wishlistProvider.clearLocalWishlist();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginSc(),
                                ),
                              );
                            },
                            context: context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: vTextWidget(
        text: title,
        color: color,
        textSize: 24,
        isTitle: true,
        fontWeight: FontWeight.bold,
      ),
      subtitle: vTextWidget(
        text: subtitle == null ? "" : subtitle,
        color: color,
        textSize: 16,
        fontWeight: FontWeight.w100,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }

  Widget _bottomsheetUpdate() {
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
                label: Text("Gallery"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
