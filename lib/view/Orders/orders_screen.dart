import 'package:e_commerce_app/constant/colors.dart';
import 'package:e_commerce_app/controller/Orders/orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});
  final OrdersController controller = Get.put(OrdersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('طلباتي',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => controller.loadOrders(),
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
        ],
      ),
      body: GetBuilder<OrdersController>(
        builder: (c) {
          if (c.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (c.errorMessage != null) {
            return _buildError(c);
          }
          if (c.orders.isEmpty) {
            return _buildEmpty();
          }
          return RefreshIndicator(
            onRefresh: c.loadOrders,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: c.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _buildOrderCard(c.orders[i], c),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 100, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text('لا توجد طلبات',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('لم تقم بإجراء أي طلب بعد',
              style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildError(OrdersController c) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(c.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: c.loadOrders,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildOrderCard(Map<String, dynamic> order, OrdersController c) {
  final status = (order['status'] ?? 'Draft').toString();
  final color = c.statusColor(status);
  final label = c.statusLabel(status);

  final total = c.totalAmountOf(order);      
  final itemsCount = c.itemsCountOf(order);  

  final dateStr = order['createdAtUtc']?.toString();
  final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
  final formatted = date != null
      ? DateFormat('yyyy/MM/dd — HH:mm').format(date)
      : '—';

  final id = (order['id'] ?? '').toString();
  final shortId = id.length > 8 ? id.substring(0, 8) : id;

  return Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Get.toNamed('/orderDetails', arguments: id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('طلب #$shortId',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(label,
                      style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(formatted,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600)),
                const Spacer(),
                Icon(Icons.inventory_2_outlined,
                    size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text('$itemsCount عنصر',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('المجموع',
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
                Text('\$${total.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
}