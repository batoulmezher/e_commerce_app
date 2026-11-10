class ProductImageModel {
  final String id;
  final String url;
  final String? contentType;
  final int? sizeBytes;

  ProductImageModel({
    required this.id,
    required this.url,
    this.contentType,
    this.sizeBytes,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: (json['id'] ?? '').toString(),
      url: (json['url'] ?? '').toString(),
      contentType: json['contentType']?.toString(),
      sizeBytes: (json['sizeBytes'] as num?)?.toInt(),
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String sku;
  final String categoryId;
  final String? categoryName;
  final List<ProductImageModel> images;

 
  final int stock;

  final DateTime? createdAtUtc;
  final DateTime? updatedAtUtc;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.sku,
    required this.categoryId,
    this.categoryName,
    this.images = const [],
    this.stock = 0,
    this.createdAtUtc,
    this.updatedAtUtc,
  });

  String? get imageUrl => images.isNotEmpty ? images.first.url : null;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final stockValue =
        json['availableQuantity'] ?? json['stock'] ?? json['quantityOnHand'];

    return ProductModel(
      id: (json['id'] ?? '').toString(),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: ((json['price'] ?? 0) as num).toDouble(),
      sku: json['sku']?.toString() ?? '',
      categoryId: (json['categoryId'] ?? '').toString(),
      categoryName: json['categoryName']?.toString(),
      images: (json['images'] as List? ?? [])
          .map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      stock: (stockValue as num?)?.toInt() ?? 0,
      createdAtUtc: json['createdAtUtc'] != null
          ? DateTime.tryParse(json['createdAtUtc'].toString())
          : null,
      updatedAtUtc: json['updatedAtUtc'] != null
          ? DateTime.tryParse(json['updatedAtUtc'].toString())
          : null,
    );
  }
}