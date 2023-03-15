import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fyp2_system/inner_screens/discountedviewall_sc.dart';
import 'package:fyp2_system/inner_screens/featured_sc.dart';
import 'package:fyp2_system/models/products_model.dart';
import 'package:fyp2_system/providers/dark_theme_provider.dart';
import 'package:fyp2_system/providers/products_provider.dart';
import 'package:fyp2_system/services/global_method.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:fyp2_system/widgets/banner_widget.dart';
import 'package:fyp2_system/widgets/categories_text.dart';
import 'package:fyp2_system/widgets/discounted_widget.dart';
import 'package:fyp2_system/widgets/emptyprod_widget.dart';
import 'package:fyp2_system/widgets/featuredprod_widget.dart';
import 'package:provider/provider.dart';
import 'package:fyp2_system/widgets/welcome_text_widget.dart';

class HomeSc extends StatefulWidget {
  const HomeSc({super.key});
  @override
  State<HomeSc> createState() => _HomeScState();
}

class _HomeScState extends State<HomeSc> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<ProductModel> listProductsSearch = [];

  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productsProvider.getProducts;
    final Color color = Utils(context).color;

    Size size = Utils(context).getScreenSize;

    List<ProductModel> discountedProducts =
        productsProvider.getDiscountedProducts;
    final themeState = Provider.of<DarkThemeProvider>(context);
    bool _isDark = themeState.getDarkTheme;

    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const WelcomeText(),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(11.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: kBottomNavigationBarHeight,
                    child: TextField(
                      focusNode: _searchTextFocusNode,
                      controller: _searchTextController,
                      onChanged: (valuee) {
                        setState(() {
                          listProductsSearch = productsProvider.searchV(valuee);
                        });
                      },
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        fillColor: _isDark ? Colors.white12 : Colors.black12,
                        filled: true,
                        hintText: 'Search here',
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: IconButton(
                            icon: const Icon(IconlyLight.search),
                            iconSize: 25,
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _searchTextController!.text.isNotEmpty &&
                      listProductsSearch.isEmpty
                  ? emptyprodSc(text: 'No products found, Please try again')
                  : _searchTextController!.text.isNotEmpty &&
                          listProductsSearch.isNotEmpty
                      ? GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          padding: EdgeInsets.fromLTRB(0, 13, 0, 0),
                          // crossAxisSpacing: 10,
                          childAspectRatio: size.width / (size.height * 0.58),
                          children: List.generate(
                              _searchTextController!.text.isNotEmpty
                                  ? listProductsSearch.length
                                  : allProducts.length, (index) {
                            return ChangeNotifierProvider.value(
                                value: _searchTextController!.text.isNotEmpty
                                    ? listProductsSearch[index]
                                    : allProducts[index],
                                child: FeedsWidget());
                          }),
                        )
                      : Column(
                          children: [
                            BannerWidget(),
                            CategoryText(isDark: _isDark),
                            //  discountedWidget(),
                            SizedBox(
                              height: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  vTextWidget(
                                    text: 'Special Offers'.toUpperCase(),
                                    color: color,
                                    textSize: 24,
                                    fontWeight: FontWeight.bold,
                                    isTitle: true,
                                  ),
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          GlobalMethods.navigateTo(
                                              ctx: context,
                                              routeName:
                                                  discountvallSc.routeName);
                                        },
                                        child: vTextWidget(
                                          text: 'View all',
                                          maxLines: 1,
                                          color: Colors.blue,
                                          textSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.28,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: ListView.builder(
                                      itemCount: discountedProducts.length < 10
                                          ? discountedProducts.length
                                          : 10,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (ctx, index) {
                                        return ChangeNotifierProvider.value(
                                            value: discountedProducts[index],
                                            child: discountedWidget());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 1),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  vTextWidget(
                                      text: 'FEATURED PRODUCTS',
                                      color: color,
                                      textSize: 24,
                                      fontWeight: FontWeight.bold),
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          GlobalMethods.navigateTo(
                                              ctx: context,
                                              routeName: FeedsScreen.routeName);
                                        },
                                        child: vTextWidget(
                                          text: 'View all',
                                          maxLines: 1,
                                          color: Colors.blue,
                                          textSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              padding: EdgeInsets.fromLTRB(0, 13, 0, 0),
                              // crossAxisSpacing: 10,
                              childAspectRatio:
                                  size.width / (size.height * 0.58),
                              children: List.generate(
                                  allProducts.length < 4
                                      ? allProducts.length //any legnth
                                      : 4, (index) {
                                return ChangeNotifierProvider.value(
                                    value: allProducts[index],
                                    child: FeedsWidget());
                              }),
                            ),
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
