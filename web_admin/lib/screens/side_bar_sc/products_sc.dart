import 'package:flutter/material.dart';
import 'package:web_admin/consts/constants.dart';
import 'package:web_admin/innersc/add_prod.dart';
import 'package:web_admin/innersc/all_products.dart';
import 'package:web_admin/responsive.dart';
import 'package:web_admin/services/utils.dart';
import 'package:web_admin/widgets/buttons.dart';
import 'package:web_admin/widgets/grid_products.dart';
import 'package:web_admin/widgets/products_header.dart';
import 'package:web_admin/widgets/text_widget.dart';

class ProductsSc extends StatelessWidget {
  static const String routeName = '\ProductsSc';

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return SafeArea(
      child: Column(
        children: [
          productsHeader(),
          SizedBox(
            height: 20,
          ),
          TextWidget(
            text: 'Latest Products',
            color: Colors.black,
            textSize: 22,
            isTitle: true,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              ButtonsWidget(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AllProductsScreen();
                  }));
                },
                text: 'View All Products',
                icon: Icons.store,
                backgroundColor: Colors.purple,
              ),
              Spacer(),
              ButtonsWidget(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UploadProductForm();
                  }));
                },
                text: 'Upload New Product',
                icon: Icons.publish_sharp,
                backgroundColor: Colors.purple,
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          const SizedBox(height: defaultPadding),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                // flex: 5,
                child: Column(
                  children: [
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
