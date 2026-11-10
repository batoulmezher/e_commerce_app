import 'package:dio/dio.dart';
import 'package:e_commerce_app/Api/api.dart';
import 'package:e_commerce_app/controller/Cart/cart_controller.dart';
import 'package:e_commerce_app/modules/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  final String productId;
  ProductDetailsController(this.productId);

  final _dio = Api().dio;
  final CartController cart = Get.find<CartController>();

  ProductModel? product;
  bool isLoading = true;
  String? errorMessage;
  int quantity = 1;

  @override
  void onInit() {
    super.onInit();
    loadProduct();
  }

  Future<void> loadProduct() async {
    isLoading = true;
    errorMessage = null;
    update();

    try {
      final res = await _dio.get('api/products/$productId');
      print('DETAILS STATUS: ${res.statusCode}');
      print('DETAILS BODY: ${res.data}');

      if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
        product = ProductModel.fromJson(res.data);
if ((product?.stock ?? 0) <= 0) quantity = 0;      } else {
        errorMessage = 'فشل تحميل المنتج';
      }
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final detail = e.response?.data?['detail'] ?? e.response?.data?['title'];
      errorMessage = '$code - ${detail ?? e.message}';
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  void increaseQty() {
    final max = product?.stock ?? 0;
    if (quantity < max) {
      quantity++;
      update();
    } else {
      Get.snackbar('تنبيه', 'لا يوجد مخزون إضافي',
          backgroundColor: Colors.orange, colorText: Colors.white);
    }
  }

  void decreaseQty() {
    if (quantity > 1) {
      quantity--;
      update();
    }
  }

  void addToCart() {
    if (product == null) return;
    if (product!.stock <= 0) {
      Get.snackbar('نفد المخزون', 'هذا المنتج غير متوفر حالياً',
          backgroundColor: Colors.red, colorText: Colors.white);
          
      return;
    }

    cart.addItem(
      productId: product!.id,
      name: product!.name,
      price: product!.price,
      imageUrl: product!.imageUrl,
      quantity: quantity,
    );

    Get.snackbar(
      'تمت الإضافة',
      '${product!.name} × $quantity أضيف إلى الطلب',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}