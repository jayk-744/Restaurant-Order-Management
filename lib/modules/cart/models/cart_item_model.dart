import '../../menu/models/menu_item_model.dart';

class CartItem {
  final MenuItemModel item;
  int qty;

  CartItem({required this.item, this.qty = 1});

  Map<String, dynamic> toJson() {
    return {'item': item.toJson(), 'qty': qty};
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      item: MenuItemModel.fromJson(json['item']),
      qty: json['qty'],
    );
  }
}
