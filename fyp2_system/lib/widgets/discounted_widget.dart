import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fyp2_system/consts/firebase_consts.dart';
import 'package:fyp2_system/inner_screens/product_details.dart';
import 'package:fyp2_system/models/products_model.dart';
import 'package:fyp2_system/providers/cart_provider.dart';
import 'package:fyp2_system/providers/dark_theme_provider.dart';
import 'package:fyp2_system/providers/viewed_provider.dart';
import 'package:fyp2_system/providers/wishlist_provider.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:fyp2_system/widgets/heart_btn.dart';
import 'package:fyp2_system/widgets/price_widget.dart';
import 'package:provider/provider.dart';

class discountedWidget extends StatefulWidget {
  const discountedWidget({super.key});

  @override
  State<discountedWidget> createState() => _discountedWidgetState();
}

class _discountedWidgetState extends State<discountedWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final themeState = Provider.of<DarkThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedProvider = Provider.of<ViewedProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);
    bool _isDark = themeState.getDarkTheme;
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            viewedProvider.addProductToHistory(productId: productModel.id);
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
            // GlobalMethods.navigateTo(
            //ctx: context, routeName: ProductDetails.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 130,
                  width: 160,
                  child: productModel.imageUrl == null
                      ? Image(
                          height: size.width * 0.28,
                          width: size.width * 0.38,
                          fit: BoxFit.fill,
                          image:
                              AssetImage('lib/assets/images/error_image.png'),
                        )
                      : PageView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: productModel.imageUrl!.length,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FancyShimmerImage(
                                height: size.width * 0.28,
                                width: size.width * 0.38,
                                imageUrl: productModel.imageUrl![index],
                                boxFit: BoxFit.fill,
                              ),
                            );
                          }),
                ),
                SizedBox(height: 5),
                // FancyShimmerImage(
                // imageUrl: productModel.imageUrl,
                // height: size.width * 0.26,
                // width: size.width * 0.35,
                // boxFit: BoxFit.fill,
                //),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 100,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: vTextWidget(
                                text: productModel.title,
                                color: color,
                                textSize: 20,
                                fontWeight: FontWeight.bold,
                                isTitle: true,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: _isInCart
                                ? null
                                : () async {
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
                                    await GlobalMethods.addToCart(
                                        productId: productModel.id,
                                        quantity: int.parse(
                                            _quantityTextController.text),
                                        context: context);
                                    await cartProvider.fetchCart();
                                    // cartProvider.addProductsToCart(
                                    // productId: productModel.id,
                                    //quantity: int.parse(
                                    //  _quantityTextController.text),
                                    //);
                                  },
                            child: Icon(
                              _isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                              color: _isInCart ? Colors.purple : color,
                              size: 22,
                            ),
                          ),
                          SizedBox(width: 10),
                          HeartBTN(
                            productId: productModel.id,
                            isInWishlist: _isInWishlist,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 2, 0, 0),
                            child: priceWidget(
                              isDark: _isDark,
                              salePrice: productModel.discountPrice,
                              price: productModel.price,
                              textPrice: _quantityTextController.text,
                              isOneSale: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
