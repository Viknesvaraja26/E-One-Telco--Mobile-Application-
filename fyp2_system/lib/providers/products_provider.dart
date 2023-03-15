import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp2_system/models/products_model.dart';

class ProductsProvider with ChangeNotifier {
  static List<ProductModel> _productsList = [];
  List<ProductModel> get getProducts {
    return _productsList;
  }

  List<ProductModel> get getDiscountedProducts {
    return _productsList.where((element) => element.isDiscounted).toList();
  }

  Future<void> fetchProducts() async {
    try {
      final productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .orderBy('createdAt')
          .get();
      _productsList = [];
      productSnapshot.docs.forEach((element) {
        final stock = int.tryParse(element['stock'].toString());
        if (stock != null && stock > 0) {
          _productsList.insert(
              0,
              ProductModel(
                id: element.get('id'),
                title: element.get('title'),
                imageUrl: List.from(element.get('imageUrl')),
                productCategoryName: element.get('productCategoryName'),
                stock: stock,
                price: double.parse(element.get('price').toString()),
                discountPrice: double.parse(
                  element.get('discountPrice').toString(),
                ),
                isDiscounted: element.get('isDiscounted'),
                productDescription: element.get('productDescription'),
              ));
        }
      });
      notifyListeners();
    } catch (error) {
      print('Error fetching products: $error');
    }
  }

  ProductModel findProdById(String productId) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> findByCategory(String categoryName) {
    List<ProductModel> _categoryList = _productsList
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  List<ProductModel> searchV(String searchByText) {
    List<ProductModel> _searchList = _productsList
        .where(
          (element) => element.title.toLowerCase().contains(
                searchByText.toLowerCase(),
              ),
        )
        .toList();
    return _searchList;
  }
}
