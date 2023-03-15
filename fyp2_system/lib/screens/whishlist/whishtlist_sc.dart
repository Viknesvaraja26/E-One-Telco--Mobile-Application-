import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fyp2_system/providers/wishlist_provider.dart';
import 'package:fyp2_system/screens/cart/empty_screen.dart';
import 'package:fyp2_system/screens/whishlist/whishlist_widget.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:fyp2_system/widgets/back_widget.dart';
import 'package:provider/provider.dart';

class WishlistSc extends StatelessWidget {
  static const routeName = "/WishlistSc";
  const WishlistSc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemList =
        wishlistProvider.getWishlistItems.values.toList().reversed.toList();
    final Color color = Utils(context).color;
    return wishlistItemList.isEmpty
        ? Scaffold(
            appBar: AppBar(
              leading: const BackWidget(),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: vTextWidget(
                text: 'Wishlist',
                color: color,
                isTitle: true,
                textSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            body: ECartSc(
              imagePath: 'lib/assets/images/no viewed.png',
              title: 'Your Wishlist is Empty',
              buttontext: 'Shop Now',
            ),
          )
        : Scaffold(
            appBar: AppBar(
                centerTitle: true,
                leading: const BackWidget(),
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: vTextWidget(
                  text: 'Wishlist (${wishlistItemList.length})',
                  color: color,
                  isTitle: true,
                  textSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      GlobalMethods.warningDialog(
                          title: 'Empty your wishlist',
                          subtitle: 'Are you sure?',
                          lastitle: 'Delete All',
                          vicon: Icon(IconlyBold.profile),
                          fct: () async {
                            await wishlistProvider.clearDatabaseWishlist();
                            wishlistProvider.clearLocalWishlist();
                          },
                          context: context);
                    },
                    icon: Icon(
                      IconlyBroken.delete,
                      color: color,
                    ),
                  ),
                ]),
            body: MasonryGridView.count(
              itemCount: wishlistItemList.length,
              crossAxisCount: 1,
              // mainAxisSpacing: 16,
              // crossAxisSpacing: 20,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                    value: wishlistItemList[index],
                    child: const WishlistWidget());
              },
            ));
  }
}
