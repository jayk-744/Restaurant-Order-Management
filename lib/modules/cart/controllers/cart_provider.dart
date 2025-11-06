import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ordermanagement/core/app_preferences.dart';

import '../../menu/models/menu_item_model.dart';
import '../models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _newItem = [];
  List<CartItem> get items => _newItem;

  double get subtotal {
    double total = 0;
    for (var element in _newItem) {
      total += element.item.price * element.qty;
    }
    return total;
  }

  double get tax => subtotal * 0.05; // 5%

  double get total => subtotal + tax;

  void getCartItems() async {
    _newItem = await AppPreferences.getCartData();
    notifyListeners();
  }

  bool isInCart(String menuItemId) {
    return _newItem.any((cartItem) => cartItem.item.id == menuItemId);
  }

  void add(MenuItemModel item) {
    final index = _newItem.indexWhere(
      (cartItem) => cartItem.item.id == item.id,
    );
    if (index != -1) {
      // item exists → update qty
      _newItem[index].qty += 1;
    } else {
      // item does not exist → add new item
      _newItem.add(CartItem(item: item, qty: 1));
    }
    notifyListeners();
    AppPreferences.updateCartData(_newItem);
  }

  void remove(String id) {
    // _items.remove(id);
    _newItem.removeWhere((cartItem) => cartItem.item.id == id);
    notifyListeners();
    AppPreferences.updateCartData(_newItem);
  }

  void changeQty(String id, int qty) {
    print(qty);
    final index = _newItem.indexWhere((cartItem) => cartItem.item.id == id);
    if (index != -1) {
      if (qty > 0) {
        _newItem[index].qty = qty;

        // return;
      } else {
        _newItem.removeAt(index);
      }
    }
    notifyListeners();
    AppPreferences.updateCartData(_newItem);
  }

  void clear() {
    _newItem.clear();
    notifyListeners();
  }
}
