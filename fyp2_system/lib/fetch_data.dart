import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fyp2_system/consts/firebase_consts.dart';
import 'package:fyp2_system/providers/cart_provider.dart';
import 'package:fyp2_system/providers/order_provider.dart';
import 'package:fyp2_system/providers/products_provider.dart';
import 'package:fyp2_system/providers/viewed_provider.dart';
import 'package:fyp2_system/providers/wishlist_provider.dart';
import 'package:fyp2_system/screens/main_sc.dart';
import 'package:provider/provider.dart';

class fetchSc extends StatefulWidget {
  const fetchSc({super.key});

  @override
  State<fetchSc> createState() => _fetchScState();
}

class _fetchScState extends State<fetchSc> {
  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 5), () async {
      final productsProvider =
          Provider.of<ProductsProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final wishlistProvider =
          Provider.of<WishlistProvider>(context, listen: false);
      final viewedProvider =
          Provider.of<ViewedProvider>(context, listen: false);
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);

      final User? user = authInstance.currentUser;

      if (user == null) {
        await productsProvider.fetchProducts();
        ordersProvider.clearLocalOrders();
        cartProvider.clearLocalCart();
        wishlistProvider.clearLocalWishlist();
        viewedProvider.clearHistory();
      } else {
        await productsProvider.fetchProducts();
        await ordersProvider.fetchOrders();
        await cartProvider.fetchCart();
        await wishlistProvider.fetchWishlist();
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const MainSc(),
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Image.asset(
          'lib/assets/images/Logoxbg.png',
          fit: BoxFit.cover,
          height: double.infinity,
        ),
        Container(
          color: Colors.black.withOpacity(0.7),
        ),
        const Center(
          child: SpinKitFadingFour(
            color: Colors.white,
          ),
        )
      ],
    ));
  }
}
