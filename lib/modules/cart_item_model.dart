import 'dart:convert';

class CartItem {
  final String productId;
  final String name;
  final double price;
  final String? imageUrl;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'price': price,
    'imageUrl': imageUrl,
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json['productId'].toString(),
    name: json['name'].toString(),
    price: (json['price'] as num).toDouble(),
    imageUrl: json['imageUrl']?.toString(),
    quantity: (json['quantity'] as num).toInt(),
  );

  static String encodeList(List<CartItem> items) =>
      jsonEncode(items.map((e) => e.toJson()).toList());

  static List<CartItem> decodeList(String? json) {
    if (json == null || json.isEmpty) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList();
  }
}