import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fyp2_system/inner_screens/product_details.dart';
import 'package:fyp2_system/models/orders_model.dart';
import 'package:fyp2_system/providers/products_provider.dart';
import 'package:fyp2_system/providers/viewed_provider.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:provider/provider.dart';

class OrderWidget extends StatefulWidget {
  const OrderWidget({Key? key}) : super(key: key);

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late String orderDateShow;

  @override
  void didChangeDependencies() {
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();
    orderDateShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<OrderModel>(context);
    final viewedProvider = Provider.of<ViewedProvider>(context);
    final ordersModel = Provider.of<OrderModel>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct =
        productProvider.findProdById(ordersModel.productId);
    final Color color = Utils(context).color;
    return ListTile(
      subtitle: Text(
          'Paid: \RM ${double.parse(ordersModel.price).toStringAsFixed(2)}'),
      onTap: () {
        viewedProvider.addProductToHistory(productId: productModel.orderId);
        Navigator.pushNamed(context, ProductDetails.routeName,
            arguments: productModel.productId);
      },
      leading: FractionallySizedBox(
        widthFactor: 0.3,
        heightFactor: 1.8,
        child: SizedBox(
          child: getCurrentProduct.imageUrl == null
              ? Image(
                  fit: BoxFit.fill,
                  image: AssetImage('lib/assets/images/error_image.png'),
                )
              : Stack(
                  children: [
                    PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: getCurrentProduct.imageUrl!.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FancyShimmerImage(
                            imageUrl: getCurrentProduct.imageUrl![index],
                            boxFit: BoxFit.fill,
                          ),
                        );
                      },
                    ),
                    if (getCurrentProduct.stock == 0)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black38,
                          child: Center(
                            child: Text(
                              'Out of Stock',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
      title: vTextWidget(
        text: '${getCurrentProduct.title}\nQuantity: ${ordersModel.quantity}',
        color: color,
        textSize: 18,
        fontWeight: FontWeight.bold,
      ),
      trailing: vTextWidget(
        text: orderDateShow,
        color: color,
        textSize: 18,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
