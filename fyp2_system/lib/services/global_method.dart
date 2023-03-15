import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2_system/auth/login_sc.dart';
import 'package:fyp2_system/consts/firebase_consts.dart';
import 'package:fyp2_system/screens/main_sc.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:uuid/uuid.dart';

class GlobalMethods {
  static navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, routeName);
  }

  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    required String lastitle,
    required fct,
    required Icon vicon,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              vicon,
              SizedBox(
                width: 8,
              ),
              Text(title),
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: vTextWidget(
                    text: "Cancel",
                    color: Colors.blue,
                    textSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  fct();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: vTextWidget(
                    text: lastitle,
                    color: Colors.red,
                    textSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          );
        });
  }

  static Future<void> LoginDialog({
    required String title,
    required String subtitle,
    required String lastitle,
    required fct,
    required Icon vicon,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              vicon,
              SizedBox(
                width: 8,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 20),
              ),
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: vTextWidget(
                    text: "Explore",
                    color: Colors.blue,
                    textSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  fct();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginSc(),
                      ),
                    );
                  }
                },
                child: vTextWidget(
                    text: lastitle,
                    color: Colors.purple,
                    textSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          );
        });
  }

  static Future<void> BackDialog({
    required String title,
    required String subtitle,
    required String lastitle,
    required fct,
    required Icon vicon,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              vicon,
              SizedBox(
                width: 8,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 20),
              ),
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MainSc(),
                      ),
                    );
                  }
                },
                child: vTextWidget(
                    text: "Return",
                    color: Colors.blue,
                    textSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  fct();
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginSc(),
                      ),
                    );
                  }
                },
                child: vTextWidget(
                    text: lastitle,
                    color: Colors.purple,
                    textSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          );
        });
  }

  static Future<void> errorDialog({
    required String subtitle,
    required Icon vicon,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              vicon,
              SizedBox(
                width: 8,
              ),
              Text('An Error has Occured'),
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: vTextWidget(
                    text: "Ok",
                    color: Colors.purple,
                    textSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          );
        });
  }

  static Future<void> emailDialog({
    required String subtitle,
    required Icon vicon,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 150,
            width: 150,
            child: AlertDialog(
              title: Row(children: [
                vicon,
                SizedBox(
                  width: 8,
                ),
                Text('Payment Success!'),
              ]),
              content: Text(subtitle),
              actions: [
                TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: vTextWidget(
                      text: "Ok",
                      color: Colors.purple,
                      textSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        });
  }

  static Future<void> passDialog({
    required String subtitle,
    required Icon vicon,
    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              vicon,
              SizedBox(
                width: 8,
              ),
              Text('Your Password has been sent to your Email Address.'),
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: vTextWidget(
                    text: "Ok",
                    color: Colors.purple,
                    textSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          );
        });
  }

  static Future<void> addToCart({
    required String productId,
    required int quantity,
    required BuildContext context,
  }) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final cartId = const Uuid().v4();

    // Retrieve the product document from Firebase
    final productDoc = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();
    final productData = productDoc.data() as Map<String, dynamic>;

    // Get the current stock of the product
    final currentStockstring = productData['stock'] as String;
    final currentStock = int.parse(currentStockstring);

    if (currentStock < quantity) {
      // If the requested quantity exceeds the current stock, show an error message and do not add the product to the cart
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Apologies'),
          content: Text('The Product is Currently out of stock.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    // Update the user's cart in Firebase
    try {
      FirebaseFirestore.instance.collection('ShopUsers').doc(_uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': quantity,
          }
        ])
      });
    } catch (e) {
      // Handle any errors that occur during the update operation
      print('Error adding product to cart: $e');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content:
              Text('An error occurred while adding the product to your cart.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  static Future<void> addToWishlist({
    required String productId,
    required BuildContext context,
  }) async {
    final User? user = authInstance.currentUser;
    final _uid = user!.uid;
    final wishlistId = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('ShopUsers').doc(_uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            'wishlistId': wishlistId,
            'productId': productId,
          }
        ])
      });
      await Fluttertoast.showToast(
          msg: "Product has been added to Wishlist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
    } catch (e) {
      errorDialog(
          subtitle: e.toString(), vicon: Icon(Icons.error), context: context);
    }
  }
}
