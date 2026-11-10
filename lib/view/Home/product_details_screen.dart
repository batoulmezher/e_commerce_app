import 'package:e_commerce_app/Api/api.dart';
import 'package:e_commerce_app/constant/colors.dart';
import 'package:e_commerce_app/controller/Cart/cart_controller.dart';
import 'package:e_commerce_app/controller/Home/product_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailsController(productId));
    final cart = Get.find<CartController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('تفاصيل المنتج',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
  GetBuilder<CartController>(
    init: cart,
    builder: (cartController) => Badge(
      label: Text('${cartController.itemCount}'),
      isLabelVisible: cartController.itemCount > 0,
      child: IconButton(
        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
        onPressed: () {
          Get.snackbar(
            'السلة',
            '${cartController.itemCount} عنصر — '
                'المجموع \$${cartController.totalPrice.toStringAsFixed(2)}',
            backgroundColor: AppColors.primary,
            colorText: Colors.white,
          );
        },
      ),
    ),
  ),
],
      ),
      body: GetBuilder<ProductDetailsController>(
        builder: (c) {
          if (c.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (c.errorMessage != null) {
            return _buildError(c.errorMessage!);
          }
          if (c.product == null) {
            return const Center(child: Text('المنتج غير موجود'));
          }

          final p = c.product!;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageGallery(p),
                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('\$${p.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold)),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                if (p.categoryName != null)
                                  _badge(p.categoryName!, Colors.blue),
                                const SizedBox(width: 8),
                                _badge('SKU: ${p.sku}', Colors.grey),
                              ],
                            ),

                            const SizedBox(height: 16),

                            if (p.description != null &&
                                p.description!.isNotEmpty) ...[
                              const Text('الوصف',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 6),
                              Text(p.description!,
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      height: 1.5)),
                              const SizedBox(height: 16),
                            ],

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: p.stock > 0
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: p.stock > 0
                                        ? Colors.green.shade200
                                        : Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                      p.stock > 0
                                          ? Icons.check_circle_outline
                                          : Icons.cancel_outlined,
                                      color: p.stock > 0
                                          ? Colors.green
                                          : Colors.red),
                                  const SizedBox(width: 8),
                                  Text(
                                    p.stock > 0
                                        ? 'متوفر: ${p.stock} قطعة'
                                        : 'نفد المخزون',
                                    style: TextStyle(
                                        color: p.stock > 0
                                            ? Colors.green.shade700
                                            : Colors.red.shade700,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              _buildBottomBar(c, p),
            ],
          );
        },
      ),
    );
  }

  Widget _buildError(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(msg, textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('رجوع'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery(dynamic product) {
    final images = product.images as List;
    if (images.isEmpty) {
      return Container(
        height: 280,
        color: Colors.grey.shade200,
        child: const Center(
            child: Icon(Icons.image_outlined,
                size: 80, color: Colors.grey)),
      );
    }
    return SizedBox(
      height: 280,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, i) {
          final url = images[i].url as String;
          final fullUrl = url.startsWith('http')
              ? url
              : '${Api().dio.options.baseUrl}$url';
          return Image.network(
            fullUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey.shade200,
              child: const Icon(Icons.broken_image,
                  size: 60, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildBottomBar(ProductDetailsController c, dynamic p) {
    final isAvailable = p.stock > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: isAvailable ? c.decreaseQty : null,
                    icon: const Icon(Icons.remove, size: 18),
                  ),
                  Text('${c.quantity}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: isAvailable ? c.increaseQty : null,
                    icon: const Icon(Icons.add, size: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAvailable
                        ? AppColors.primary
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: isAvailable ? c.addToCart : null,
                  icon: const Icon(Icons.add_shopping_cart,
                      color: Colors.white),
                  label: Text(
                    isAvailable
                        ? 'أضف للطلب (\$${(p.price * c.quantity).toStringAsFixed(2)})'
                        : 'نفد المخزون',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}