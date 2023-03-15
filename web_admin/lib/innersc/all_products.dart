import 'package:flutter/material.dart';
import 'package:web_admin/consts/constants.dart';
import 'package:web_admin/responsive.dart';
import 'package:web_admin/services/utils.dart';
import 'package:web_admin/widgets/buttons.dart';
import 'package:web_admin/widgets/grid_products.dart';
import 'package:web_admin/widgets/products_header.dart';
import 'package:web_admin/widgets/text_widget.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      backgroundColor: Colors.purple[50],
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    children: [
                      productsHeader(),
                      SizedBox(
                        height: 20,
                      ),
                      TextWidget(
                        text: 'All Products',
                        color: Colors.black,
                        textSize: 24,
                        isTitle: true,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ButtonsWidget(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icons.arrow_back_outlined,
                              text: 'Return',
                              backgroundColor: Colors.purple,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Responsive(
                        mobile: ProductGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 3,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                          isInMain: false,
                        ),
                        desktop: ProductGridWidget(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                          isInMain: false,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
