import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_admin/services/utils.dart';
import 'package:web_admin/widgets/products_widget.dart';
//import 'package:mailer/mailer.dart';
//import 'package:mailer/smtp_server.dart';

import 'text_widget.dart';

class OrdersWidget extends StatefulWidget {
  OrdersWidget(
      {Key? key,
      required this.price,
      required this.totalPrice,
      required this.productId,
      required this.userId,
      required this.imageUrl,
      required this.userName,
      required this.quantity,
      required this.orderDate,
      required this.addressLine1,
      required this.addressLine2,
      required this.city,
      required this.email,
      required this.state,
      required this.zipcode})
      : super(key: key);
  final double price, totalPrice;
  final String productId, userId, userName;
  final String addressLine1, addressLine2, city, email, state, zipcode;
  final List<String>? imageUrl;
  final int quantity;
  final Timestamp orderDate;

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  String? mytoken = "";
  late String orderDateShow;
  @override
  void initState() {
    var postDate = widget.orderDate.toDate();
    orderDateShow = '${postDate.day}/${postDate.month}/${postDate.year}';

    super.initState();
  }

  bool _isSent = true;
  bool _isbutactive = true;
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                  flex: size.width < 650 ? 6 : 5,
                  child: SizedBox(
                    height: 180,
                    width: 180,
                    child: widget.imageUrl == null
                        ? Image(
                            width: size.height * 20,
                            height: size.width * 0.17,
                            fit: BoxFit.fill,
                            image:
                                AssetImage('lib/assets/images/error_image.png'),
                          )
                        : PageView.builder(
                            scrollBehavior: AppScrollBehavior(),
                            itemCount: widget.imageUrl!.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FancyShimmerImage(
                                  width: size.height * 20,
                                  height: size.width * 0.17,
                                  imageUrl: widget.imageUrl![index],
                                  boxFit: BoxFit.fill,
                                ),
                              );
                            }),
                  )),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text:
                          '\tQuantity:\t${widget.quantity}\n\tTotal: RM ${widget.price.toStringAsFixed(2)}',
                      color: color,
                      textSize: 26,
                      isTitle: true,
                    ),
                    FittedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TextWidget(
                                text: '\tOrdered By',
                                color: Colors.blue,
                                textSize: 20,
                                isTitle: true,
                              ),
                              TextWidget(
                                text: '\t${widget.email}',
                                color: color,
                                textSize: 18,
                                isTitle: true,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextWidget(
                                text: '\tName:\t${widget.userName}',
                                color: color,
                                textSize: 18,
                                isTitle: true,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextWidget(
                                text:
                                    '\tAddress:\n\t\t${widget.addressLine1},\n\t\t${widget.addressLine2},\n\t\t${widget.zipcode}\t\t${widget.city},\n\t\t${widget.state}.',
                                color: color,
                                textSize: 18,
                                isTitle: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\tDate: ${orderDateShow}',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: _isbutactive
                            ? () {
                                setState(() {
                                  if (_isSent == true) {
                                    _isbutactive = false;
                                  } else if (_isSent == false) {
                                    _isbutactive = true;
                                  }
                                });
                                Future.delayed(
                                  Duration(seconds: 0),
                                  () => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Row(children: [
                                            SizedBox(
                                              height: 50,
                                              width: 400,
                                              child: Column(
                                                children: [
                                                  TextField(
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            'Please Input the Courier Service'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                          content: TextField(
                                            decoration: InputDecoration(
                                                hintText:
                                                    'Please Input the tracking ID'),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (Navigator.canPop(
                                                      context)) {
                                                    Navigator.pop(context);
                                                    _isbutactive = true;
                                                  }
                                                });
                                              },
                                              child: TextWidget(
                                                color: Colors.cyan,
                                                text: 'Cancel',
                                                textSize: 18,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                await EasyLoading.show();
                                                setState(() {
                                                  // sendEmail();
                                                  _isSent = !_isSent;
                                                });

                                                await EasyLoading.showSuccess(
                                                    'Successfully Deleted');

                                                await EasyLoading.dismiss();
                                                await Fluttertoast.showToast(
                                                  msg: "Notification Sent",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                );
                                                //while (Navigator.canPop(
                                                // context)) {
                                                Navigator.pop(context);
                                                // }
                                              },
                                              child: TextWidget(
                                                color: Colors.red,
                                                text: 'Confirm',
                                                textSize: 18,
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                );
                              }
                            : null,
                        child: _isSent
                            ? Icon(
                                CupertinoIcons.bell_fill,
                                color: Colors.purple,
                                size: 50,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.purple),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Notified User',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* void sendEmail() async {
    FirebaseFirestore.instance
    .collection('users')
    .doc(widget.userId)
    .get()
    .then((DocumentSnapshot documentSnapshot) {
  if (documentSnapshot.exists) {
    String userEmail = documentSnapshot.get('email');
    // Send email notification here
  }
});
    String username = 'your_email_address';
    String password = 'your_email_password';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Your Name')
      ..recipients.add(userEmail) // User email address retrieved from Firebase
      ..subject = 'Order Notification'
      ..text = 'Your order has been received.'
      ..html = '<h1>Your order has been received.</h1>';

    send(message, smtpServer);
  }*/
}
