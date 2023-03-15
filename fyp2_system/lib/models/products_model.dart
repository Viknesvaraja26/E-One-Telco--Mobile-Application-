import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final String id, title, productCategoryName, productDescription;
  final List<String>? imageUrl;
  final double price, discountPrice;
  final int stock;
  final bool isDiscounted;

  ProductModel(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.productCategoryName,
      required this.stock,
      required this.price,
      required this.discountPrice,
      required this.isDiscounted,
      required this.productDescription});
}
