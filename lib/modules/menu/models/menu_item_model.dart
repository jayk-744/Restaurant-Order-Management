class MenuItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> j) => MenuItemModel(
    id: j['id'],
    name: j['name'],
    description: j['description'] ?? '',
    price: (j['price'] as num).toDouble(),
    imageUrl: j['imageUrl'] ?? 'https://picsum.photos/200',
  );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "imageUrl": imageUrl,
    };
  }
}
