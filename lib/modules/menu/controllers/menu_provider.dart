import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/menu_category_model.dart';
import '../models/menu_item_model.dart';

class MenuProvider extends ChangeNotifier {
  List<MenuCategory> categories = [];
  bool loading = false;

  Future<void> loadMenuData() async {
    loading = true;
    // notifyListeners();

    try {
      final jsonStr = await rootBundle.loadString('assets/menu.json');

      final data = json.decode(jsonStr) as List;
      categories = (data).map((c) {
        final items = (c['items'] as List)
            .map((it) => MenuItemModel.fromJson(it))
            .toList();
        return MenuCategory(id: c['id'], name: c['name'], items: items);
      }).toList();
    } catch (e) {
      // categories = _sampleCategories();
      categories = [];
    }
    loading = false;
    notifyListeners();
  }
}
