import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/consts/constants.dart';
import 'package:web_admin/widgets/orders_widget.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({Key? key, this.isInDash = true}) : super(key: key);
  final bool isInDash;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('ShopUsers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: isInDash && snapshot.data!.docs.length > 5
                    ? 5
                    : snapshot.data!.docs.length,
                itemBuilder: (ctx, index) {
                  final userDoc = snapshot.data!.docs[index];
                  return StreamBuilder<QuerySnapshot>(
                    stream: userDoc.reference.collection('orders').snapshots(),
                    builder: (context, ordersSnapshot) {
                      if (ordersSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (ordersSnapshot.connectionState ==
                          ConnectionState.active) {
                        if (ordersSnapshot.data!.docs.isNotEmpty) {
                          return Column(
                            children: [
                              ...ordersSnapshot.data!.docs.map((orderDoc) {
                                return Column(
                                  children: [
                                    OrdersWidget(
                                      price: orderDoc['price'],
                                      totalPrice: orderDoc['totalPrice'],
                                      productId: orderDoc['productId'],
                                      userId: orderDoc['userId'],
                                      imageUrl: List.from(orderDoc['imageUrl']),
                                      userName: userDoc['name'],
                                      quantity: orderDoc['quantity'],
                                      orderDate: orderDoc['orderDate'],
                                      addressLine1: userDoc['address Line1'],
                                      addressLine2: userDoc['address Line2'],
                                      zipcode: userDoc['zipcode'],
                                      city: userDoc['city'],
                                      state: userDoc['state'],
                                      email: userDoc['email'],
                                    ),
                                    const Divider(
                                      thickness: 3,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ],
                          );
                        } else {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Text(
                                'Thats all for today!   🫰',
                                style: TextStyle(color: Colors.purple),
                              ),
                            ),
                          );
                        }
                      } else {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text('Something went wrong!'),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('No orders found!'),
              ),
            );
          }
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Text('Something went wrong!'),
            ),
          );
        }
      },
    );
  }
}
