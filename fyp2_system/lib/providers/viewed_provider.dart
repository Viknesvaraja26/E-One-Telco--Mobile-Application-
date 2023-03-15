import 'package:flutter/material.dart';
import 'package:fyp2_system/models/viewed_model.dart';

class ViewedProvider with ChangeNotifier {
  Map<String, ViewedModel> _viewedlistItems = {};

  Map<String, ViewedModel> get getViewedlistItems {
    return _viewedlistItems;
  }

  void addProductToHistory({required String productId}) {
    _viewedlistItems.putIfAbsent(productId,
        () => ViewedModel(id: DateTime.now().toString(), productId: productId));

    notifyListeners();
  }

  void clearHistory() {
    _viewedlistItems.clear();
    notifyListeners();
  }
}
