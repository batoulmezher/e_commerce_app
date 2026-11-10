import 'package:dio/dio.dart';
import 'package:e_commerce_app/Api/api.dart';
import 'package:e_commerce_app/modules/cart_item_model.dart';

class OrdersService {
  final Dio _dio = Api().dio;

  Future<Map<String, dynamic>> createOrder(List<CartItem> cartItems) async {
    if (cartItems.isEmpty) {
      throw Exception('السلة فارغة');
    }

    Map<String, dynamic>? lastResponse;

    try {
      for (final item in cartItems) {
        final res = await _dio.post(
          'api/orders/items',
          data: {
            "productId": item.productId,
            "qty": item.quantity,   
          },
        );

        print('ADD ITEM STATUS: ${res.statusCode}');
        print('ADD ITEM BODY: ${res.data}');

        lastResponse = res.data as Map<String, dynamic>;
      }

      return lastResponse ?? {};
    } on DioException catch (e) {
      final msg = e.response?.data?['detail'] ??
          e.response?.data?['title'] ??
          e.message ??
          'خطأ غير معروف';
      throw Exception('${e.response?.statusCode ?? ""} - $msg');
    }
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final res = await _dio.get('api/orders');
      print('ORDERS STATUS: ${res.statusCode}');
      print('ORDERS BODY: ${res.data}');

      final dynamic raw = res.data;
      List list;
      if (raw is List) {
        list = raw;
      } else if (raw is Map) {
        list = (raw['items'] ?? raw['data'] ?? []) as List;
      } else {
        list = [];
      }
      return list.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      final msg = e.response?.data?['detail'] ??
          e.response?.data?['title'] ??
          e.message ??
          'خطأ غير معروف';
      throw Exception('${e.response?.statusCode ?? ""} - $msg');
    }
  }

  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      final res = await _dio.get('api/orders/$orderId');
      print('ORDER DETAILS STATUS: ${res.statusCode}');
      print('ORDER DETAILS BODY: ${res.data}');
      return res.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final msg = e.response?.data?['detail'] ??
          e.response?.data?['title'] ??
          e.message ??
          'خطأ غير معروف';
      throw Exception('${e.response?.statusCode ?? ""} - $msg');
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final res = await _dio.put(
        'api/orders/$orderId/status',
        data: {"status": newStatus},
      );
      print('UPDATE ORDER STATUS: ${res.statusCode}');
    } on DioException catch (e) {
      final msg = e.response?.data?['detail'] ??
          e.response?.data?['title'] ??
          e.message ??
          'خطأ غير معروف';
      throw Exception('${e.response?.statusCode ?? ""} - $msg');
    }
  }
Future<Map<String, dynamic>> confirmOrder(String orderId) async {
  try {
    final res = await _dio.post(
      'api/orders/confirm',
      data: {"orderId": orderId},
    );
    print('CONFIRM STATUS: ${res.statusCode}');
    print('CONFIRM BODY: ${res.data}');
    return res.data as Map<String, dynamic>;
  } on DioException catch (e) {
    final msg = e.response?.data?['detail'] ??
        e.response?.data?['title'] ??
        e.message ??
        'خطأ غير معروف';
    throw Exception('${e.response?.statusCode ?? ""} - $msg');
  }
}

Future<Map<String, dynamic>> checkoutOrder(String orderId) async {
  try {
    final res = await _dio.post(
      'api/orders/checkout',
      data: {"orderId": orderId},
    );
    print('CHECKOUT STATUS: ${res.statusCode}');
    print('CHECKOUT BODY: ${res.data}');
    return res.data as Map<String, dynamic>;
  } on DioException catch (e) {
    final msg = e.response?.data?['detail'] ??
        e.response?.data?['title'] ??
        e.message ??
        'خطأ غير معروف';
    throw Exception('${e.response?.statusCode ?? ""} - $msg');
  }
}
Future<Map<String, dynamic>> submitOrder(String orderId) async {
  try {
    final res = await _dio.post(
      'api/orders/submit',  
      data: {"orderId": orderId},
    );
    print('SUBMIT STATUS: ${res.statusCode}');
    print('SUBMIT BODY: ${res.data}');
    return res.data as Map<String, dynamic>;
  } on DioException catch (e) {
    final msg = e.response?.data?['detail'] ??
        e.response?.data?['title'] ??
        e.message ??
        'خطأ غير معروف';
    throw Exception('${e.response?.statusCode ?? ""} - $msg');
  }
}
Future<Map<String, dynamic>> cancelOrder(String orderId) async {
  try {
    final res = await _dio.post(
      'api/orders/cancel',
      data: {"orderId": orderId},
    );
    print('CANCEL STATUS: ${res.statusCode}');
    print('CANCEL BODY: ${res.data}');
    return res.data as Map<String, dynamic>;
  } on DioException catch (e) {
    final msg = e.response?.data?['detail'] ??
        e.response?.data?['title'] ??
        e.message ??
        'خطأ غير معروف';
    throw Exception('${e.response?.statusCode ?? ""} - $msg');
  }
}
}