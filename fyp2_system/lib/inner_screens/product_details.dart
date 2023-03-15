import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fyp2_system/consts/firebase_consts.dart';
import 'package:fyp2_system/providers/cart_provider.dart';
import 'package:fyp2_system/providers/products_provider.dart';
import 'package:fyp2_system/providers/wishlist_provider.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:fyp2_system/widgets/heart_btn.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  const ProductDetails({Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;

    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProvider.findProdById(productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    bool? _isInCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    double usedPrice = getCurrentProduct.isDiscounted
        ? getCurrentProduct.discountPrice
        : getCurrentProduct.price;
    double totalPrice = usedPrice * int.parse(_quantityTextController.text);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);

    //final viewedProvider = Provider.of<ViewedProvider>(context);
    /* child: WillPopScope(
          onWillPop: () async {
            // viewedProvider.addProductToHistory(productId: productId);
            return true;
          },)*/
    //Save history but effected by navigator.pop(context) <<

    return Scaffold(
      appBar: AppBar(
          leading: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () =>
                Navigator.canPop(context) ? Navigator.pop(context) : null,
            child: Icon(
              IconlyLight.arrowLeft2,
              color: color,
              size: 24,
            ),
          ),
          //toolbarHeight: 25,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: Column(children: [
        Flexible(
            flex: 3,
            child: SizedBox(
              width: 400,
              child: getCurrentProduct.imageUrl == null
                  ? Image(
                      height: size.width * 0.28,
                      width: size.width * 0.38,
                      fit: BoxFit.fill,
                      image: AssetImage('lib/assets/images/error_image.png'),
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
          flex: 6,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            height: 55,
                            child: ListView(
                              children: [
                                vTextWidget(
                                  text: getCurrentProduct.title,
                                  color: color,
                                  textSize: 25,
                                  isTitle: true,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      HeartBTN(
                        productId: getCurrentProduct.id,
                        isInWishlist: _isInWishlist,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      vTextWidget(
                        text: '\RM${usedPrice.toStringAsFixed(2)} / ',
                        color: Colors.green,
                        textSize: 22,
                        isTitle: true,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: getCurrentProduct.isDiscounted ? true : false,
                        child: vTextWidget(
                            text: 'Price ',
                            color: Colors.white,
                            textSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Visibility(
                        visible: getCurrentProduct.isDiscounted ? true : false,
                        child: Text(
                          '\RM${getCurrentProduct.price.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 16,
                              color: color,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.red,
                              decorationThickness: 1.8),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(5)),
                        child: vTextWidget(
                          text: 'Free delivery',
                          color: Colors.white,
                          textSize: 20,
                          isTitle: true,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    quantityControl(
                      fct: () {
                        if (_quantityTextController.text == '1') {
                          return;
                        } else {
                          setState(() {
                            _quantityTextController.text =
                                (int.parse(_quantityTextController.text) - 1)
                                    .toString();
                          });
                        }
                      },
                      icon: CupertinoIcons.minus,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      flex: 1,
                      child: TextField(
                        controller: _quantityTextController,
                        key: const ValueKey('quantity'),
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        textAlign: TextAlign.center,
                        cursorColor: Colors.green,
                        enabled: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              _quantityTextController.text = '1';
                            } else {}
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    quantityControl(
                      fct: () {
                        setState(() {
                          _quantityTextController.text =
                              (int.parse(_quantityTextController.text) + 1)
                                  .toString();
                        });
                      },
                      icon: CupertinoIcons.plus,
                      color: Colors.green,
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 180,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: vTextWidget(
                                    text: 'Product Description',
                                    color: color,
                                    textSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: vTextWidget(
                                  text: getCurrentProduct.productDescription,
                                  color: color,
                                  textSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(thickness: 1),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            vTextWidget(
                              text: 'Total',
                              color: Colors.red.shade300,
                              textSize: 20,
                              isTitle: true,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            FittedBox(
                              child: Row(
                                children: [
                                  vTextWidget(
                                    text: '\RM${totalPrice.toStringAsFixed(2)}',
                                    color: color,
                                    textSize: 20,
                                    isTitle: true,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  vTextWidget(
                                    text:
                                        '\ / ${_quantityTextController.text} items',
                                    color: color,
                                    textSize: 16,
                                    isTitle: false,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Material(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
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
                                        productId: getCurrentProduct.id,
                                        quantity: int.parse(
                                            _quantityTextController.text),
                                        context: context);
                                    await cartProvider.fetchCart();
                                    //if (_isInCart) {
                                    //return;
                                    //}
                                    /*cartProvider.addProductsToCart(
                                      productId: getCurrentProduct.id,
                                      quantity: int.parse(
                                          _quantityTextController.text),
                                    );*/
                                  },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: vTextWidget(
                                    text: _isInCart ? 'Added' : 'Add to cart',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    textSize: 18)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Widget quantityControl(
      {required Function fct, required IconData icon, required Color color}) {
    return Flexible(
      flex: 2,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: color,
        child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
            )),
      ),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
