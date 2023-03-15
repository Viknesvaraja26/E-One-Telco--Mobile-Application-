import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web_admin/innersc/edit_product.dart';
import 'package:web_admin/services/global_method.dart';
import 'package:web_admin/services/utils.dart';
import 'text_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  String title = '';
  String productCat = '';
  String price = '0.0';
  String stock = '0';
  double discountedPrice = 0.0;
  bool isDiscounted = false;
  String productDescription = '';
  List<String>? _imageUrl = [];

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    try {
      final DocumentSnapshot productsDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .get();
      // ignore: unnecessary_null_comparison
      if (productsDoc == null) {
        return;
      } else {
        title = productsDoc.get('title');
        stock = productsDoc.get('stock');
        productCat = productsDoc.get('productCategoryName');
        _imageUrl = List.from(productsDoc.get('imageUrl'));
        price = productsDoc.get('price');
        discountedPrice = productsDoc.get('discountPrice');
        isDiscounted = productsDoc.get('isDiscounted');
        productDescription = productsDoc.get('productDescription');
      }
    } catch (error) {
      setState(() {
        EasyLoading.dismiss();
      });
      GlobalMethods.errorDialog(
          subtitle: '$error',
          context: context,
          vicon: Icon(Icons.error_outline));
    } finally {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    final color = Utils(context).color;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.6),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => editProducts(
                      id: widget.id,
                      title: title,
                      price: price,
                      stock: stock,
                      discountedPrice: discountedPrice,
                      productCat: productCat,
                      isDiscounted: isDiscounted,
                      description: productDescription,
                    )));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 15, 8),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          flex: size.width < 650 ? 3 : 2,
                          child: SizedBox(
                            height: 300,
                            width: 500,
                            child: _imageUrl == null
                                ? Image(
                                    width: size.height * 20,
                                    height: size.width * 0.17,
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'lib/assets/images/error_image.png'),
                                  )
                                : PageView.builder(
                                    scrollBehavior: AppScrollBehavior(),
                                    itemCount: _imageUrl!.length,
                                    itemBuilder: (context, index) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FancyShimmerImage(
                                          width: size.height * 20,
                                          height: size.width * 0.17,
                                          imageUrl: _imageUrl![index],
                                          boxFit: BoxFit.fill,
                                        ),
                                      );
                                    }),
                          )),
                      SizedBox(width: 5),
                      PopupMenuButton(
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () {
                                    Future.delayed(
                                      Duration(seconds: 0),
                                      () => showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Row(children: [
                                                Icon(Icons.warning_amber_sharp),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                Text('Delete?'),
                                              ]),
                                              content:
                                                  Text('Press okay to confirm'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async {
                                                    if (Navigator.canPop(
                                                        context)) {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: TextWidget(
                                                    color: Colors.cyan,
                                                    text: 'Cancel',
                                                    textSize: 18,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await EasyLoading.show();
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('products')
                                                        .doc(widget.id)
                                                        .delete();
                                                    Navigator.pop(context);
                                                    await EasyLoading.showSuccess(
                                                        'Successfully Deleted');
                                                    await EasyLoading.dismiss();
                                                    await Fluttertoast
                                                        .showToast(
                                                      msg:
                                                          "Product has been deleted",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                    );
                                                  },
                                                  child: TextWidget(
                                                    color: Colors.red,
                                                    text: 'Delete',
                                                    textSize: 18,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    );
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  value: 1,
                                ),
                              ])
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: 'Stock:\t${stock}',
                        color: color,
                        textSize: 23,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                    ],
                  ),
                  Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: isDiscounted
                            ? 'RM ${discountedPrice.toStringAsFixed(2)}'
                            : 'RM $price',
                        color: color,
                        textSize: 23,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Visibility(
                          visible: isDiscounted,
                          child: Text(
                            'RM $price',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: color),
                          )),
                    ],
                  ),
                  Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    text: '$title',
                    color: color,
                    textSize: 24,
                    isTitle: true,
                  ),
                  Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: 'Product Category: ',
                    color: color,
                    textSize: 18,
                    isTitle: true,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextWidget(
                    text: '$productCat',
                    color: color,
                    textSize: 16,
                    isTitle: true,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: 'Product Description: ',
                    color: color,
                    textSize: 18,
                    isTitle: true,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextWidget(
                    text: '$productDescription',
                    color: color,
                    textSize: 16,
                    isTitle: true,
                  ),
                ],
              ),
            ),
          ),
        ),
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
