import 'package:flutter/material.dart';
import 'package:fyp2_system/models/products_model.dart';
import 'package:fyp2_system/providers/products_provider.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:fyp2_system/widgets/back_widget.dart';
import 'package:fyp2_system/widgets/discounted_widget.dart';
import 'package:fyp2_system/widgets/emptyprod_widget.dart';
import 'package:provider/provider.dart';

class discountvallSc extends StatelessWidget {
  static const routeName = "/discountvallSc";
  const discountvallSc({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> discountedProducts =
        productsProvider.getDiscountedProducts;

    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: vTextWidget(
          text: 'SPCIAL OFFERS',
          color: color,
          textSize: 24.0,
          isTitle: true,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: discountedProducts.isEmpty
          ? emptyprodSc(
              text: 'Currently No Offers Available...\n\nComing Soon!!!')
          : GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.fromLTRB(0, 13, 0, 30),
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.58),
              children: List.generate(discountedProducts.length, (index) {
                return ChangeNotifierProvider.value(
                    value: discountedProducts[index],
                    child: discountedWidget());
              }),
            ),
    );
  }
}
