import 'package:e_commerce_app/services/orders_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  final OrdersService _service = OrdersService();

  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading = true;
    errorMessage = null;
    update();

    try {
      orders = await _service.getOrders();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  double totalAmountOf(Map<String, dynamic> order) {
    final items = (order['items'] as List?) ?? [];
    double total = 0;
    for (final item in items) {
      final qty = (item['qty'] as num?)?.toInt() ?? 0;
      final price = (item['price'] as num?)?.toDouble() ?? 0;
      total += qty * price;
    }
    return total;
  }

  int itemsCountOf(Map<String, dynamic> order) {
    final items = (order['items'] as List?) ?? [];
    int count = 0;
    for (final item in items) {
      count += (item['qty'] as num?)?.toInt() ?? 0;
    }
    return count;
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return Colors.grey;
      case 'pending':
        return Colors.orange;
      case 'confirmed':
      case 'approved':
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'cancelled':
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return 'مسودة';
      case 'pending':
        return 'قيد الانتظار';
      case 'confirmed':
        return 'مؤكد';
      case 'processing':
        return 'قيد التحضير';
      case 'shipped':
        return 'تم الشحن';
      case 'delivered':
        return 'تم التوصيل';
      case 'cancelled':
      case 'canceled':
        return 'ملغى';
      default:
        return status;
    }
  }
}