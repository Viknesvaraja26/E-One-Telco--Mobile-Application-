import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2_system/consts/firebase_consts.dart';
import 'package:fyp2_system/main.dart';
import 'package:fyp2_system/providers/cart_provider.dart';
import 'package:fyp2_system/providers/order_provider.dart';
import 'package:fyp2_system/providers/products_provider.dart';
import 'package:fyp2_system/screens/cart/cart_widget.dart';
import 'package:fyp2_system/screens/cart/empty_screen.dart';
import 'package:fyp2_system/screens/main_sc.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:fyp2_system/widgets/featuredprodtext_widget.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartSc extends StatefulWidget {
  static const routeName = "/cartSc";
  const CartSc({Key? key}) : super(key: key);

  @override
  State<CartSc> createState() => _CartScState();
}

class _CartScState extends State<CartSc> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemList =
        cartProvider.getCartItems.values.toList().reversed.toList();

    return cartItemList.isEmpty
        ? WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: AppBar(
                // automaticallyImplyLeading: false,
                leading: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MainSc();
                    }));
                  },
                  child: Icon(IconlyLight.arrowLeft2, color: color),
                ),
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: vTextWidget(
                  text: '\t\tCart',
                  color: color,
                  textSize: 26,
                  isTitle: true,
                  fontWeight: FontWeight.bold,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          title: 'Error',
                          subtitle: 'Please login',
                          lastitle: 'OK',
                          vicon: Icon(Icons.error),
                          fct: () {},
                          context: context);
                    },
                    icon: Icon(
                      IconlyBold.delete, //icon.,
                      color: color,
                    ),
                  ),
                ],
              ),
              body: ECartSc(
                title: 'Your Shopping Cart is empty',
                buttontext: 'Continue Shopping',
                imagePath: 'lib/assets/images/no-product-found.png',
              ),
            ),
          )
        : WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: AppBar(
                // automaticallyImplyLeading: false,
                leading: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MainSc();
                    }));
                  },
                  child: Icon(IconlyLight.arrowLeft2, color: color),
                ),
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: vTextWidget(
                  text: '\t\tCart(${cartItemList.length})',
                  color: color,
                  textSize: 26,
                  isTitle: true,
                  fontWeight: FontWeight.bold,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          title: 'Empty Your Cart',
                          subtitle: 'Are you sure?',
                          lastitle: 'Delete All',
                          vicon: Icon(IconlyBold.delete),
                          fct: () async {
                            await cartProvider.clearDatabaseCart();
                            cartProvider.clearLocalCart();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete, //icon.,
                      color: color,
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  _checkout(ctx: context),
                  Expanded(
                    child: ListView.builder(
                        itemCount: cartItemList.length,
                        itemBuilder: (ctx, index) {
                          return ChangeNotifierProvider.value(
                              value: cartItemList[index],
                              child: CartWidget(
                                quan: cartItemList[index].quantity,
                              ));
                        }),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _checkout({required BuildContext ctx}) {
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;

    final cartProvider = Provider.of<CartProvider>(ctx);
    final productsProvider = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);

    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrentProd = productsProvider.findProdById(value.productId);
      total += (getCurrentProd.isDiscounted
              ? getCurrentProd.discountPrice
              : getCurrentProd.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          children: [
            Material(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  final orderId = const Uuid().v4();
                  final productProvider =
                      Provider.of<ProductsProvider>(ctx, listen: false);
                  final cartItems = cartProvider.getCartItems;

                  try {
                    final User? user = authInstance.currentUser;
                    final _uid = user!.uid;
                    final productsCollection =
                        FirebaseFirestore.instance.collection('products');

                    await FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      // Collect all the products to be updated in a list
                      final List<Map<String, dynamic>> updatedProducts = [];
                      for (final value in cartItems.values) {
                        final getCurrentProd =
                            productProvider.findProdById(value.productId);
                        if (getCurrentProd == null) {
                          throw Exception(
                              'Product not found: ${value.productId}');
                        }

                        final productSnapshot = await transaction
                            .get(productsCollection.doc(getCurrentProd.id));

                        if (!productSnapshot.exists) {
                          throw Exception(
                              'Product not found in database: ${getCurrentProd.id}');
                        }

                        final currentStock =
                            int.parse(productSnapshot.get('stock'));
                        if (currentStock < value.quantity) {
                          throw Exception('Not enough stock to fulfill order');
                        }

                        updatedProducts.add({
                          'id': getCurrentProd.id,
                          'quantity': value.quantity,
                          'currentStock': currentStock,
                          'isDiscounted': getCurrentProd.isDiscounted,
                          'discountPrice': getCurrentProd.discountPrice,
                          'price': getCurrentProd.price,
                          'imageUrl': getCurrentProd.imageUrl,
                        });
                      }

                      await initPayment(
                          email: user.email ?? '',
                          amount: total * 100,
                          context: ctx);

                      // Update all the products in the list
                      for (final product in updatedProducts) {
                        final newStock =
                            product['currentStock'] - product['quantity'];
                        final price = (product['isDiscounted']
                                ? product['discountPrice']
                                : product['price']) *
                            product['quantity'];
                        transaction.update(
                            productsCollection.doc(product['id']),
                            {'stock': newStock.toString()});

                        await FirebaseFirestore.instance
                            .collection('ShopUsers')
                            .doc(_uid)
                            .collection('orders')
                            .doc(orderId)
                            .set({
                          'orderId': orderId,
                          'userId': user.uid,
                          'productId': product['id'],
                          'price': price,
                          'quantity': product['quantity'],
                          'imageUrl': product['imageUrl'],
                          'stock': newStock,
                          'userName': user.displayName,
                          'email': user.email,
                          'paymentStatus': 'Not paid',
                          'orderDate': Timestamp.now(),
                        });
                      }

                      await FirebaseFirestore.instance
                          .collection('ShopUsers')
                          .doc(_uid)
                          .collection('orders')
                          .doc(orderId)
                          .update({
                        'totalPrice': total,
                      });
                    });

                    await FirebaseFirestore.instance
                        .collection('ShopUsers')
                        .doc(_uid)
                        .collection('orders')
                        .doc(orderId)
                        .update({
                      'paymentStatus': 'paid',
                    });

                    await GlobalMethods.emailDialog(
                      subtitle:
                          'Your order will be shipped within 7 days.\nTracking id will be sent to \t${user.email} after your order is shipped. \n\nTHANK YOU!!',
                      vicon: Icon(Icons.email),
                      context: context,
                    );

                    NotificationDetails notificationDetails =
                        NotificationDetails(
                      android: AndroidNotificationDetails(
                        channel.id,
                        channel.name,
                        importance: Importance.high,
                        color: Colors.purple,
                        playSound: true,
                        icon: '@mipmap/ic_launcher',
                      ),
                    );
                    flutterLocalNotificationsPlugin.show(
                      0,
                      'One Store Telco',
                      'Your Products will be shipped in few days, Thank You for using E-One',
                      notificationDetails,
                    );

                    await cartProvider.clearDatabaseCart();
                    cartProvider.clearLocalCart();
                    ordersProvider.fetchOrders();
                    await Fluttertoast.showToast(
                      msg: 'Your order has been placed',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                  } catch (e) {
                    GlobalMethods.errorDialog(
                      subtitle: e.toString(),
                      vicon: Icon(Icons.error),
                      context: ctx,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: fTextWidget(
                    text: 'Order Now',
                    textSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Spacer(),
            FittedBox(
              child: fTextWidget(
                text: 'Total: \RM${total.toStringAsFixed(2)}',
                color: color,
                textSize: 18,
                isTitle: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initPayment(
      {required String email,
      required double amount,
      required BuildContext context}) async {
    try {
      //create payment intent on the server>>
      final response = await http.post(
          Uri.parse(
              'https://us-central1-telco-system-app.cloudfunctions.net/stripePaymentIntentRequest'),
          body: {
            'email': email,
            'amount': amount.toString(),
          });

      //initialize payment>>
      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      if (jsonResponse['success'] == false) {
        GlobalMethods.errorDialog(
            subtitle: jsonResponse['error'],
            vicon: Icon(Icons.error),
            context: context);
        throw jsonResponse['error'];
      }
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: jsonResponse['paymentIntent'],
        merchantDisplayName: 'One Store Telco',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
      ));

      //complete payment
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: const Text(
        'Payment Successful',
        style: TextStyle(color: Colors.white),
      )));
    } catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occured ${e.error.localizedMessage}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occured $e',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
      throw '$e';
    }
  }
}
