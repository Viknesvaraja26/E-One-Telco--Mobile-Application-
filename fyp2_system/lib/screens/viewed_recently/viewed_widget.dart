import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fyp2_system/consts/firebase_consts.dart';
import 'package:fyp2_system/models/viewed_model.dart';
import 'package:fyp2_system/providers/cart_provider.dart';
import 'package:fyp2_system/providers/products_provider.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:provider/provider.dart';

class ViewedRecentlyWidget extends StatefulWidget {
  const ViewedRecentlyWidget({Key? key}) : super(key: key);

  @override
  _ViewedRecentlyWidgetState createState() => _ViewedRecentlyWidgetState();
}

class _ViewedRecentlyWidgetState extends State<ViewedRecentlyWidget> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);

    final viewedModel = Provider.of<ViewedModel>(context);

    final getCurrProduct = productProvider.findProdById(viewedModel.productId);
    double usedPrice = getCurrProduct.isDiscounted
        ? getCurrProduct.discountPrice
        : getCurrProduct.price;

    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(getCurrProduct.id);

    Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          //  GlobalMethods.navigateTo(
          //  ctx: context, routeName: ProductDetails.routeName);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: getCurrProduct.imageUrl == null
                  ? Image(
                      height: size.width * 0.28,
                      width: size.width * 0.38,
                      fit: BoxFit.fill,
                      image: AssetImage('lib/assets/images/error_image.png'),
                    )
                  : PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: getCurrProduct.imageUrl!.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FancyShimmerImage(
                            height: size.width * 0.28,
                            width: size.width * 0.38,
                            imageUrl: getCurrProduct.imageUrl![index],
                            boxFit: BoxFit.fill,
                          ),
                        );
                      }),
            ),
            // FancyShimmerImage(
            //  imageUrl: getCurrProduct.imageUrl,
            // boxFit: BoxFit.fill,
            // height: size.width * 0.27,
            // width: size.width * 0.25,
            //),
            const SizedBox(
              width: 12,
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
                  width: 200,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: vTextWidget(
                      text: getCurrProduct.title,
                      color: color,
                      textSize: 24,
                      isTitle: true,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                vTextWidget(
                  text: '\RM${usedPrice.toStringAsFixed(2)}',
                  color: color,
                  textSize: 20,
                  isTitle: false,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green,
                child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _isInCart
                        ? null
                        : () async {
                            final User? user = authInstance.currentUser;
                            if (user == null) {
                              GlobalMethods.errorDialog(
                                  subtitle: 'Please Login',
                                  vicon: Icon(Icons.error),
                                  context: context);
                              return;
                            }
                            await GlobalMethods.addToCart(
                                productId: getCurrProduct.id,
                                quantity: 1,
                                context: context);
                            await cartProvider.fetchCart();
                            /*cartProvider.addProductsToCart(
                              productId: getCurrProduct.id,
                              quantity: 1,
                            );*/
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        _isInCart ? Icons.check : IconlyBold.plus,
                        color: Colors.white,
                        size: 20,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
