import 'package:e_commerce_app/Api/api.dart';
import 'package:e_commerce_app/modules/category_model.dart';
import 'package:e_commerce_app/modules/product_model.dart';

class HomeService {
  static const bool USE_MOCK = false;

  // ============ Categories ============
  Future<List<CategoryModel>> getCategories() async {
    if (USE_MOCK) {
      await Future.delayed(const Duration(milliseconds: 300));
      return [
        CategoryModel(id: 'cat-1', name: 'Electronics'),
        CategoryModel(id: 'cat-2', name: 'Clothing'),
        CategoryModel(id: 'cat-3', name: 'Books'),
      ];
    }

    try {
      final res = await Api().dio.get('api/categories');
      print('CATEGORIES STATUS: ${res.statusCode}');
      print('CATEGORIES BODY: ${res.data}');

      final dynamic raw = res.data;
      List list;
      if (raw is List) {
        list = raw;
      } else if (raw is Map) {
        list = (raw['items'] ?? raw['data'] ?? []) as List;
      } else {
        list = [];
      }
      return list.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      print('❌ getCategories error: $e');
      return [];
    }
  }

  // ============ Products ============
  Future<Map<String, dynamic>> getProducts({
    String? categoryId,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (USE_MOCK) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {
        'items': <Map<String, dynamic>>[],
        'page': page,
        'pageSize': pageSize,
        'totalCount': 0,
        'totalPages': 0,
      };
    }

    try {
      final res = await Api().dio.get(
        'api/v2/Products',
        queryParameters: {
          if (categoryId != null && categoryId.isNotEmpty)
            'categoryId': categoryId, 
          'page': page,
          'pageSize': pageSize,
        },
      );

      print('PRODUCTS STATUS: ${res.statusCode}');
      print('PRODUCTS BODY: ${res.data}');

      final body = (res.data as Map<String, dynamic>?) ?? {};
      final List items = (body['items'] ?? []) as List;

      return {
        'items': items.map((e) => ProductModel.fromJson(e)).toList(),
        'page': (body['page'] as num?)?.toInt() ?? page,
        'pageSize': (body['pageSize'] as num?)?.toInt() ?? pageSize,
        'totalCount': (body['totalCount'] as num?)?.toInt() ?? 0,
        'totalPages': (body['totalPages'] as num?)?.toInt() ?? 0,
      };
    } catch (e) {
      print('❌ getProducts error: $e');
      return {
        'items': <ProductModel>[],
        'page': page,
        'pageSize': pageSize,
        'totalCount': 0,
        'totalPages': 0,
      };
    }
  }
}