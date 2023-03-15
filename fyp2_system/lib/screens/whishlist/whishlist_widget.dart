import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fyp2_system/inner_screens/product_details.dart';
import 'package:fyp2_system/models/wishlist_model.dart';
import 'package:fyp2_system/providers/products_provider.dart';
import 'package:fyp2_system/providers/wishlist_provider.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:fyp2_system/widgets/heart_btn.dart';
import 'package:provider/provider.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistModel = Provider.of<WishlistModel>(context);
    final getCurrentProduct =
        productProvider.findProdById(wishlistModel.productId);
    double usedPrice = getCurrentProduct.isDiscounted
        ? getCurrentProduct.discountPrice
        : getCurrentProduct.price;
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetails.routeName,
              arguments: wishlistModel.productId);
        },
        child: Container(
          height: size.height * 0.20,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: color, width: 1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Flexible(
                  flex: 2,
                  child: SizedBox(
                    height: 300,
                    width: 400,
                    child: getCurrentProduct.imageUrl == null
                        ? Image(
                            height: size.width * 0.28,
                            width: size.width * 0.38,
                            fit: BoxFit.fill,
                            image:
                                AssetImage('lib/assets/images/error_image.png'),
                          )
                        : PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: getCurrentProduct.imageUrl!.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FancyShimmerImage(
                                  height: size.width * 0.28,
                                  width: size.width * 0.38,
                                  imageUrl: getCurrentProduct.imageUrl![index],
                                  boxFit: BoxFit.fill,
                                ),
                              );
                            }),
                  )),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                IconlyLight.bag2,
                                color: color,
                              ),
                            ),
                            HeartBTN(
                              productId: getCurrentProduct.id,
                              isInWishlist: _isInWishlist,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: vTextWidget(
                        text: getCurrentProduct.title,
                        color: color,
                        textSize: 20.0,
                        maxLines: 2,
                        isTitle: true,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    vTextWidget(
                      text: '\RM${usedPrice.toStringAsFixed(2)}',
                      color: color,
                      textSize: 18.0,
                      maxLines: 1,
                      isTitle: true,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
