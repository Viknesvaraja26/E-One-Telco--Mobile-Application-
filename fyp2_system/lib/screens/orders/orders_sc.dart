import 'package:flutter/material.dart';
import 'package:fyp2_system/providers/order_provider.dart';
import 'package:fyp2_system/screens/cart/empty_screen.dart';
import 'package:fyp2_system/screens/orders/orders_widget.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:fyp2_system/widgets/back_widget.dart';
import 'package:provider/provider.dart';

class OrdersSc extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersSc({Key? key}) : super(key: key);

  @override
  State<OrdersSc> createState() => _OrdersScState();
}

class _OrdersScState extends State<OrdersSc> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;

    final ordersProvider = Provider.of<OrdersProvider>(context);
    final ordersList = ordersProvider.getOrders;

    if (ordersList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: vTextWidget(
            text: 'Orders',
            color: color,
            isTitle: true,
            textSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: ECartSc(
          imagePath: 'lib/assets/images/no viewed.png',
          title: '\n\tNo orders have been placed',
          buttontext: 'Shop Now',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        centerTitle: false,
        title: vTextWidget(
          text: 'Your orders (${ordersList.length})',
          color: color,
          textSize: 26.0,
          isTitle: true,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
      ),
      body: FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          return ListView.separated(
            itemCount: ordersList.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: 12,
                ),
                child: ChangeNotifierProvider.value(
                  value: ordersList[index],
                  child: OrderWidget(),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: color,
                thickness: 1,
              );
            },
          );
        },
      ),
    );
  }
}
