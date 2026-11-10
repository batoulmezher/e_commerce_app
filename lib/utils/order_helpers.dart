import 'package:flutter/material.dart';

class OrderHelpers {
  static Color statusColor(String status) {
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

  static String statusLabel(String status) {
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

  static double totalAmountOf(Map<String, dynamic> order) {
    final items = (order['items'] as List?) ?? [];
    double total = 0;
    for (final item in items) {
      final qty = (item['qty'] as num?)?.toInt() ?? 0;
      final price = (item['price'] as num?)?.toDouble() ?? 0;
      total += qty * price;
    }
    return total;
  }

  static int itemsCountOf(Map<String, dynamic> order) {
    final items = (order['items'] as List?) ?? [];
    int count = 0;
    for (final item in items) {
      count += (item['qty'] as num?)?.toInt() ?? 0;
    }
    return count;
  }
}