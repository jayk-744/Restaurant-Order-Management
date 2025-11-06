import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../modules/cart/models/cart_item_model.dart';

class AppPreferences {
  // const static String isDark = 'isDark';

  static updateCartData(List<CartItem> cartData) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = cartData.map((cartItem) => cartItem.toJson()).toList();
    await prefs.setString('cartData', jsonEncode(jsonList));
  }

  static Future<List<CartItem>> getCartData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('cartData');
    if (jsonString == null) return [];
    final decodedList = jsonDecode(jsonString) as List;

    return decodedList.map((json) => CartItem.fromJson(json)).toList();
    // return jsonDecode(jsonString);
  }

  static clearCartData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('cartData');
  }
}
