import 'package:flutter/material.dart';
import 'package:fyp2_system/models/products_model.dart';
import 'package:fyp2_system/providers/products_provider.dart';
import 'package:fyp2_system/services/utils.dart';
import 'package:fyp2_system/widgets/accounttext_widget.dart';
import 'package:fyp2_system/widgets/back_widget.dart';
import 'package:fyp2_system/widgets/emptyprod_widget.dart';
import 'package:fyp2_system/widgets/featuredprod_widget.dart';
import 'package:provider/provider.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = "/FeedsScreenState";
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();

  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    productsProvider.fetchProducts();
    super.initState();
  } //if any double products comment this initstate!

  List<ProductModel> listProductsSearch = [];

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productsProvider.getProducts;
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: vTextWidget(
          text: 'All Products',
          color: color,
          textSize: 20.0,
          isTitle: true,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: kBottomNavigationBarHeight,
              child: TextField(
                focusNode: _searchTextFocusNode,
                controller: _searchTextController,
                onChanged: (valuee) {
                  setState(() {
                    listProductsSearch = productsProvider.searchV(valuee);
                  }); //search all
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.greenAccent, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.greenAccent, width: 1),
                  ),
                  hintText: "What's in your mind",
                  prefixIcon: const Icon(Icons.search),
                  suffix: IconButton(
                    onPressed: () {
                      _searchTextController!.clear();
                      _searchTextFocusNode.unfocus();
                    },
                    icon: Icon(
                      Icons.close,
                      color: _searchTextFocusNode.hasFocus ? Colors.red : color,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _searchTextController!.text.isNotEmpty && listProductsSearch.isEmpty
              ? emptyprodSc(text: 'No products found, Please try again')
              : GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  padding: EdgeInsets.fromLTRB(0, 13, 0, 30),
                  // crossAxisSpacing: 10,
                  childAspectRatio: size.width / (size.height * 0.59),
                  children: List.generate(
                      _searchTextController!.text.isNotEmpty
                          ? listProductsSearch.length
                          : allProducts.length, (index) {
                    return ChangeNotifierProvider.value(
                        value: _searchTextController!.text.isNotEmpty
                            ? listProductsSearch[index]
                            : allProducts[index],
                        child: const FeedsWidget());
                  }),
                ),
        ]),
      ),
    );
  }
}
