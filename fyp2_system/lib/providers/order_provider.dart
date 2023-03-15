import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2_system/consts/firebase_consts.dart';
import 'package:fyp2_system/models/orders_model.dart';

class OrdersProvider with ChangeNotifier {
  static List<OrderModel> _orders = [];
  List<OrderModel> get getOrders {
    return _orders;
  }

  Future<void> fetchOrders() async {
    User? user = authInstance.currentUser;
    final _uid = user!.uid;
    await FirebaseFirestore.instance
        .collection('ShopUsers')
        .doc(_uid)
        .collection('orders')
        //.orderBy('orderDate', descending: true)
        .where("userId", isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot ordersSnapshot) {
      _orders = [];
      //_orders.clear();
      ordersSnapshot.docs.forEach((element) {
        _orders.insert(
            0,
            OrderModel(
              orderId: element.get('orderId'),
              userId: element.get('userId'),
              productId: element.get('productId'),
              // email: element.get('email'),
              userName: element.get('userName'),
              orderDate: element.get('orderDate'),
              price: element.get('price').toString(),
              // stock: element.get('stock'),
              imageUrl: List.from(element.get('imageUrl')),
              quantity: element.get('quantity').toString(),
              // addressLine1: element.get('address Line1'),
              // addressLine2: element.get('address Line2'),
              // zipcode: element.get('zipcode'),
              //  city: element.get('city'),
              // state: element.get('state'),
            ));
      });
    });
    notifyListeners();
  }

  void clearLocalOrders() {
    _orders.clear();
    notifyListeners();
  }
}
