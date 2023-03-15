import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp2_system/consts/firebase_consts.dart';
import 'package:fyp2_system/inner_screens/product_details.dart';
import 'package:fyp2_system/models/products_model.dart';
import 'package:fyp2_system/providers/cart_provider.dart';
import 'package:fyp2_system/providers/dark_theme_provider.dart';
import 'package:fyp2_system/providers/viewed_provider.dart';
import 'package:fyp2_system/providers/wishlist_provider.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/widgets/heart_btn.dart';
import 'package:fyp2_system/widgets/price_widget.dart';
import 'package:fyp2_system/widgets/featuredprodtext_widget.dart';
import 'package:provider/provider.dart';
import '../services/utils.dart';

class FeedsWidget extends StatefulWidget {
  static const routeName = "/feedItemsSc";
  const FeedsWidget({Key? key}) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final viewedProvider = Provider.of<ViewedProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);

    bool _isDark = themeState.getDarkTheme;
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 8, 8),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () {
            viewedProvider.addProductToHistory(productId: productModel.id);
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
            //GlobalMethods.navigateTo(
            // ctx: context, routeName: ProductDetails.routeName);
          },
          borderRadius: BorderRadius.circular(12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 130,
                width: 350,
                child: productModel.imageUrl == null
                    ? Image(
                        height: size.width * 0.28,
                        width: size.width * 0.30,
                        fit: BoxFit.fill,
                        image: AssetImage('lib/assets/images/error_image.png'),
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
                              width: size.width * 0.30,
                              imageUrl: productModel.imageUrl![index],
                              boxFit: BoxFit.fill,
                            ),
                          );
                        }),
              ),
            ),
            //SizedBox(
            // height: 8,
            // ),
            // FancyShimmerImage(
            //imageUrl: productModel.imageUrl,
            // height: size.width * 0.28,
            // width: size.width * 0.38,
            // boxFit: BoxFit.fill,
            //),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: fTextWidget(
                      text: productModel.title,
                      maxLines: 1,
                      color: color,
                      textSize: 18,
                      isTitle: true,
                    ),
                  ),
                  HeartBTN(
                    productId: productModel.id,
                    isInWishlist: _isInWishlist,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 8, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 3,
                    child: priceWidget(
                      isDark: _isDark,
                      salePrice: productModel.discountPrice,
                      price: productModel.price,
                      textPrice: _quantityTextController.text,
                      isOneSale: productModel.isDiscounted ? true : false,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _isInCart
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
                        // if (_isInCart) {
                        //   return;
                        // }
                        await GlobalMethods.addToCart(
                            productId: productModel.id,
                            quantity: int.parse(_quantityTextController.text),
                            context: context);
                        await cartProvider.fetchCart();
                      },
                child: fTextWidget(
                  text: _isInCart ? 'Added' : 'Add to cart',
                  maxLines: 1,
                  color: color,
                  textSize: 20,
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).cardColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                    )),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
