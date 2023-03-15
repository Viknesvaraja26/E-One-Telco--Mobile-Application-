import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp2_system/inner_screens/product_details.dart';
import 'package:fyp2_system/models/cart_model.dart';
import 'package:fyp2_system/providers/cart_provider.dart';
import 'package:fyp2_system/providers/products_provider.dart';
import 'package:fyp2_system/providers/wishlist_provider.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/heart_btn.dart';
import 'package:fyp2_system/widgets/featuredprodtext_widget.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key, required this.quan}) : super(key: key);
  final int quan;

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = widget.quan.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    final cartModel = Provider.of<CartModel>(context);
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final getCurrentProduct = productProvider.findProdById(cartModel.productId);
    double usedPrice = getCurrentProduct.isDiscounted
        ? getCurrentProduct.discountPrice
        : getCurrentProduct.price;
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: cartModel.productId);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(13, 10, 13, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: size.width * 0.28,
                      width: size.width * 0.28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: SizedBox(
                        height: size.width * 0.28,
                        width: size.width * 0.28,
                        child: getCurrentProduct.imageUrl == null
                            ? Image(
                                height: size.width * 0.28,
                                width: size.width * 0.38,
                                fit: BoxFit.fill,
                                image: AssetImage(
                                    'lib/assets/images/error_image.png'),
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
                                      imageUrl:
                                          getCurrentProduct.imageUrl![index],
                                      boxFit: BoxFit.fill,
                                    ),
                                  );
                                }),
                      ),
                      //FancyShimmerImage(
                      //imageUrl: getCurrentProduct.imageUrl,
                      //boxFit: BoxFit.fill,
                      //),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 2),
                          child: SizedBox(
                            height: 60,
                            width: 100,
                            child: SingleChildScrollView(
                              child: fTextWidget(
                                text: getCurrentProduct.title,
                                color: color,
                                textSize: 18,
                                isTitle: true,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        SizedBox(
                          width: size.width * 0.28,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                _quantityController(
                                  fct: () {
                                    if (_quantityTextController.text == '1') {
                                      return;
                                    } else {
                                      cartProvider.reduceQuantityByOne(
                                          cartModel.productId);
                                      setState(() {
                                        _quantityTextController.text =
                                            (int.parse(_quantityTextController
                                                        .text) -
                                                    1)
                                                .toString();
                                      });
                                    }
                                  },
                                  color: Colors.red,
                                  icon: CupertinoIcons.minus,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: TextField(
                                    controller: _quantityTextController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]'),
                                      ),
                                    ],
                                    onChanged: (v) {
                                      setState(() {
                                        if (v.isEmpty) {
                                          _quantityTextController.text = '1';
                                        } else {
                                          return;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                _quantityController(
                                  fct: () {
                                    cartProvider.increaseQuantityByOne(
                                        cartModel.productId);
                                    setState(() {
                                      _quantityTextController.text = (int.parse(
                                                  _quantityTextController
                                                      .text) +
                                              1)
                                          .toString();
                                    });
                                  },
                                  color: Colors.green,
                                  icon: CupertinoIcons.add,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              await cartProvider.removeOneItem(
                                cartId: cartModel.id,
                                productId: cartModel.productId,
                                quantity: cartModel.quantity,
                              );
                            },
                            child: const Icon(
                              CupertinoIcons.cart_badge_minus,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          HeartBTN(
                            productId: getCurrentProduct.id,
                            isInWishlist: _isInWishlist,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          fTextWidget(
                            text:
                                '\RM ${(usedPrice * int.parse(_quantityTextController.text)).toStringAsFixed(2)}',
                            color: color,
                            textSize: 18,
                            maxLines: 1,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  Widget _quantityController({
    required Function fct,
    required IconData icon,
    required Color color,
  }) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
