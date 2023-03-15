import 'package:flutter/material.dart';
import 'package:web_admin/widgets/buttons.dart';
import 'package:web_admin/widgets/orders_list.dart';
import 'package:web_admin/widgets/text_widget.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  @override
  Widget build(BuildContext context) {
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
                  child: Column(
                    children: [
                      // ordersHeader(),
                      SizedBox(
                        height: 20,
                      ),
                      TextWidget(
                        text: 'All Orders',
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
                            Spacer(),
                            ButtonsWidget(
                              onPressed: () {},
                              text: 'Edit Orders',
                              icon: Icons.edit,
                              backgroundColor: Colors.purple,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: OrdersList(isInDash: false),
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
