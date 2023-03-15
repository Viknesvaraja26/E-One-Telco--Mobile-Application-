import 'package:flutter/material.dart';
import 'package:web_admin/consts/constants.dart';
import 'package:web_admin/innersc/all_orders_screen.dart';
import 'package:web_admin/widgets/buttons.dart';
import 'package:web_admin/widgets/orders_list.dart';
import 'package:web_admin/widgets/text_widget.dart';

class OrdersSc extends StatelessWidget {
  static const String routeName = '\OrdersSc';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            //ordersHeader(),
            SizedBox(
              height: 20,
            ),
            TextWidget(
              text: 'Recent Orders',
              color: Colors.black,
              textSize: 24,
              isTitle: true,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                ButtonsWidget(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AllOrdersScreen();
                    }));
                  },
                  text: 'View All Orders',
                  icon: Icons.store,
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
                      /* Responsive(
                        mobile: ProductGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                        ),
                        desktop: ProductGridWidget(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                        ),
                      ),*/
                      const OrdersList(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
