import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fyp2_system/consts/firebase_consts.dart';
import 'package:fyp2_system/providers/products_provider.dart';
import 'package:fyp2_system/providers/wishlist_provider.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:provider/provider.dart';

class HeartBTN extends StatefulWidget {
  const HeartBTN({Key? key, required this.productId, this.isInWishlist = false})
      : super(key: key);
  final String productId;
  final bool? isInWishlist;

  @override
  State<HeartBTN> createState() => _HeartBTNState();
}

class _HeartBTNState extends State<HeartBTN> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProvider.findProdById(widget.productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final Color color = Utils(context).color;
    return GestureDetector(
      onTap: () async {
        setState(() {
          loading = true;
        });
        try {
          final User? user = authInstance.currentUser;
          if (user == null) {
            GlobalMethods.LoginDialog(
                title: 'Error',
                subtitle: 'Please Log in 😅',
                lastitle: 'Login Now',
                fct: () {},
                vicon: Icon(Icons.error),
                context: context);
            return;
          }
          if (widget.isInWishlist == false && widget.isInWishlist != null) {
            await GlobalMethods.addToWishlist(
                productId: widget.productId, context: context);
          } else {
            await wishlistProvider.removeOneWishItem(
                wishlistId:
                    wishlistProvider.getWishlistItems[getCurrentProduct.id]!.id,
                productId: widget.productId);
          }
          await wishlistProvider.fetchWishlist();
          setState(() {
            loading = false;
          });
        } catch (e) {
          GlobalMethods.errorDialog(
            subtitle: '$e',
            vicon: Icon(Icons.error),
            context: context,
          );
          setState(() {
            loading = false;
          });
        } finally {
          setState(() {
            loading = false;
          });
        }
        //wishlistProvider.addRemoveProductToWishlist(productId: productId); local method for local use only
      },
      child: loading
          ? const SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(color: Colors.blue))
          : Icon(
              widget.isInWishlist != null && widget.isInWishlist == true
                  ? IconlyBold.heart
                  : IconlyLight.heart,
              size: 22,
              color: widget.isInWishlist != null && widget.isInWishlist == true
                  ? Colors.red
                  : color,
            ),
    );
  }
}
