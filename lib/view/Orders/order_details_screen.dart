import 'package:e_commerce_app/constant/colors.dart';
import 'package:e_commerce_app/controller/Orders/orders_controller.dart';
import 'package:e_commerce_app/services/orders_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:e_commerce_app/utils/order_helpers.dart';
class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final OrdersService _service = OrdersService();

  Map<String, dynamic>? order;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final data = await _service.getOrderById(widget.orderId);
      setState(() => order = data);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

 Future<void> _confirmOrder() async {
  final confirm = await Get.defaultDialog<bool>(
    title: 'تأكيد الطلب',
    middleText: 'هل أنت متأكد من تأكيد هذا الطلب؟',
    textConfirm: 'تأكيد',
    textCancel: 'إلغاء',
    confirmTextColor: Colors.white,
    buttonColor: Colors.green,
    onConfirm: () => Get.back(result: true),
    onCancel: () => Get.back(result: false),
  );

  if (confirm != true) return;

  Get.dialog(
    const Center(child: CircularProgressIndicator()),
    barrierDismissible: false,
  );

  try {
    await _service.confirmOrder(widget.orderId);
    Get.back();
    Get.snackbar('نجح', 'تم تأكيد الطلب',
        backgroundColor: Colors.green, colorText: Colors.white);
    _loadOrder();
  } catch (e) {
    Get.back();
    Get.snackbar('فشل', e.toString(),
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}

Future<void> _cancelOrder() async {
  final confirm = await Get.defaultDialog<bool>(
    title: 'إلغاء الطلب',
    middleText: 'هل أنت متأكد من إلغاء هذا الطلب؟',
    textConfirm: 'نعم، إلغاء',
    textCancel: 'تراجع',
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,
    onConfirm: () => Get.back(result: true),
    onCancel: () => Get.back(result: false),
  );

  if (confirm != true) return;

  Get.dialog(
    const Center(child: CircularProgressIndicator()),
    barrierDismissible: false,
  );

  try {
    await _service.cancelOrder(widget.orderId);
    Get.back();
    Get.snackbar('نجح', 'تم إلغاء الطلب',
        backgroundColor: Colors.green, colorText: Colors.white);
    _loadOrder();
  } catch (e) {
    Get.back();
    Get.snackbar('فشل', e.toString(),
        backgroundColor: Colors.red, colorText: Colors.white);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('تفاصيل الطلب',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOrder,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildContent() {
  if (order == null) return const Center(child: Text('لا توجد بيانات'));

  final status = (order!['status'] ?? 'Draft').toString();
  final color = OrderHelpers.statusColor(status);    
  final label = OrderHelpers.statusLabel(status);     
  final total = OrderHelpers.totalAmountOf(order!);   

  final dateStr = order!['createdAtUtc']?.toString();
  final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
  final formatted = date != null
      ? DateFormat('yyyy/MM/dd — HH:mm').format(date)
      : '—';

  final items = (order!['items'] as List?) ?? [];

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _rowKV('رقم الطلب',
                  widget.orderId.length > 8
                      ? widget.orderId.substring(0, 8)
                      : widget.orderId),
              const SizedBox(height: 8),
              _rowKV('التاريخ', formatted),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('الحالة',
                      style:
                          TextStyle(color: Colors.grey, fontSize: 13)),
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
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (items.isNotEmpty) ...[
          const Text('العناصر',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...items.map((item) => _buildItemCard(item)),
          const SizedBox(height: 16),
        ],
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('المجموع الكلي',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$${total.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildActions(status),
      ],
    ),
  );
}
Widget _rowKV(String k, String v) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(k,
          style: const TextStyle(color: Colors.grey, fontSize: 13)),
      Text(v, style: const TextStyle(fontSize: 13)),
    ],
  );
}

Widget _buildItemCard(Map<String, dynamic> item) {
  final productId = item['productId']?.toString() ?? '';
  final qty = (item['qty'] as num?)?.toInt() ?? 0;
  final price = (item['price'] as num?)?.toDouble() ?? 0;
  final subtotal = qty * price;

  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'منتج ${productId.length > 8 ? productId.substring(0, 8) : productId}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('$qty × \$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
        ),
        Text('\$${subtotal.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

 

 Widget _buildActions(String status) {
  final lower = status.toLowerCase();
  final canConfirm = lower == 'draft' || lower == 'pending';
  final canCancel = lower == 'draft' || lower == 'pending' || lower == 'confirmed';

  if (!canConfirm && !canCancel) {
    return const SizedBox();
  }

  return Row(
    children: [
      if (canConfirm)
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _confirmOrder,
            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
            label: const Text('تأكيد الطلب',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      if (canConfirm && canCancel) const SizedBox(width: 12),
      if (canCancel)
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _cancelOrder,
            icon: const Icon(Icons.cancel_outlined, color: Colors.white),
            label: const Text('إلغاء الطلب',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
    ],
  );
}
}