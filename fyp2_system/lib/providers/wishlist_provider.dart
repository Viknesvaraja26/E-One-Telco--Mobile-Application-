import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2_system/models/wishlist_model.dart';

import '../consts/firebase_consts.dart';

class WishlistProvider with ChangeNotifier {
  Map<String, WishlistModel> _wishlistItems = {};

  Map<String, WishlistModel> get getWishlistItems {
    return _wishlistItems;
  }

/*  void addRemoveProductToWishlist({required String productId}) {
    if (_wishlistItems.containsKey(productId)) {
      removeOneItem(productId);
    } else {
      _wishlistItems.putIfAbsent(
          productId,
          () => WishlistModel(
              id: DateTime.now().toString(), productId: productId));
    }
    notifyListeners();
  }*/

  final userCollection = FirebaseFirestore.instance.collection('ShopUsers');
  Future<void> fetchWishlist() async {
    final User? user = authInstance.currentUser;
    final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();

    if (userDoc == false) {
      return;
    }
    final leng = userDoc.get('userWish').length;
    for (int i = 0; i < leng; i++) {
      _wishlistItems.putIfAbsent(
          userDoc.get('userWish')[i]['productId'],
          () => WishlistModel(
                id: userDoc.get('userWish')[i]['wishlistId'],
                productId: userDoc.get('userWish')[i]['productId'],
              ));
    }
    notifyListeners();
  }

  Future<void> removeOneWishItem({
    required String wishlistId,
    required String productId,
  }) async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userWish': FieldValue.arrayRemove([
        {
          'wishlistId': wishlistId,
          'productId': productId,
        }
      ])
    });
    _wishlistItems.remove(productId);
    await fetchWishlist();
    notifyListeners();
  }

  Future<void> clearDatabaseWishlist() async {
    final User? user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userWish': [],
      //FieldValue.delete(); //this method will delete userWish field in firebase do not use!!!
    });
    _wishlistItems.clear();
    notifyListeners();
  }

  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
