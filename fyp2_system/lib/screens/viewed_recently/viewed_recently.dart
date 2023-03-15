import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fyp2_system/providers/viewed_provider.dart';
import 'package:fyp2_system/screens/cart/empty_screen.dart';
import 'package:fyp2_system/screens/viewed_recently/viewed_widget.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:fyp2_system/widgets/back_widget.dart';
import 'package:provider/provider.dart';

class ViewedRecentlySc extends StatefulWidget {
  static const routeName = '/ViewedRecentlyScreen';

  const ViewedRecentlySc({Key? key}) : super(key: key);

  @override
  _ViewedRecentlyScState createState() => _ViewedRecentlyScState();
}

class _ViewedRecentlyScState extends State<ViewedRecentlySc> {
  bool check = true;
  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    final viewedProvider = Provider.of<ViewedProvider>(context);
    final viewedItemList =
        viewedProvider.getViewedlistItems.values.toList().reversed.toList();
    if (viewedItemList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: const BackWidget(),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: vTextWidget(
            text: 'Viewed History',
            color: color,
            isTitle: true,
            textSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: ECartSc(
          imagePath: 'lib/assets/images/no viewed.png',
          title: 'No Products has been viewed',
          buttontext: 'Shop Now',
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                GlobalMethods.warningDialog(
                    title: 'Empty your history?',
                    subtitle: 'Are you sure to empty Viewed History?',
                    lastitle: 'Empty',
                    vicon: Icon(IconlyBold.delete),
                    fct: () {
                      viewedProvider.clearHistory();
                    },
                    context: context);
              },
              icon: Icon(
                IconlyBroken.delete,
                color: color,
              ),
            )
          ],
          leading: const BackWidget(),
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          title: vTextWidget(
            text: 'History',
            color: color,
            textSize: 26.0,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        body: ListView.builder(
            itemCount: viewedItemList.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: ChangeNotifierProvider.value(
                    value: viewedItemList[index],
                    child: ViewedRecentlyWidget()),
              );
            }),
      );
    }
  }
}
