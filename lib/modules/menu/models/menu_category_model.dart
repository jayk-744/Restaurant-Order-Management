import 'menu_item_model.dart';

class MenuCategory {
  final String id;
  final String name;
  final List<MenuItemModel> items;

  MenuCategory({required this.id, required this.name, required this.items});

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    // var list = json['items'] as List;
    // List<MenuItem> items = list.map((e) => MenuItem.fromJson(e)).toList();

    return MenuCategory(
      id: json['id'],
      name: json['name'],
      items: json['items'].map((e) => MenuItemModel.fromJson(e)).toList(),
    );
  }
}
