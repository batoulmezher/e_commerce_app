import 'package:e_commerce_app/modules/cart_item_model.dart';
import 'package:e_commerce_app/services/orders_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartController extends GetxController {
  final GetStorage _box = GetStorage();
  static const _key = 'cart';
final OrdersService _ordersService = OrdersService();
bool isPlacingOrder = false;
  final List<CartItem> items = [];

  @override
  void onInit() {
    super.onInit();
    _load();
  }
Future<bool> placeOrder() async {
  if (items.isEmpty) {
    Get.snackbar('خطأ', 'السلة فارغة',
        backgroundColor: Colors.red, colorText: Colors.white);
    return false;
  }

  isPlacingOrder = true;
  update();

  try {
    final created = await _ordersService.createOrder(items);

    final orderId = created['id']?.toString();
    if (orderId == null || orderId.isEmpty) {
      throw Exception('لم يتم استلام orderId من السيرفر');
    }

    await _ordersService.checkoutOrder(orderId);

    Get.snackbar('نجح', 'تم إنشاء طلبك بنجاح!',
        backgroundColor: Colors.green, colorText: Colors.white);

    clear(); 
    return true;
  } catch (e) {
    Get.snackbar('فشل', e.toString(),
        backgroundColor: Colors.red, colorText: Colors.white);
    return false;
  } finally {
    isPlacingOrder = false;
    update();
  }
}
  void _load() {
    items.assignAll(CartItem.decodeList(_box.read(_key)));
    update();
  }

  void _save() {
    _box.write(_key, CartItem.encodeList(items));
    update();
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => items.fold(0.0, (sum, item) => sum + item.subtotal);

  void addItem({
    required String productId,
    required String name,
    required double price,
    String? imageUrl,
    int quantity = 1,
  }) {
    final index = items.indexWhere((e) => e.productId == productId);
    if (index >= 0) {
      items[index].quantity += quantity;
    } else {
      items.add(CartItem(
        productId: productId,
        name: name,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity,
      ));
    }
    _save();
  }

  void removeItem(String productId) {
    items.removeWhere((e) => e.productId == productId);
    _save();
  }

  void updateQuantity(String productId, int quantity) {
    final index = items.indexWhere((e) => e.productId == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        items.removeAt(index);
      } else {
        items[index].quantity = quantity;
      }
      _save();
    }
  }

  void clear() {
    items.clear();
    _save();
  }
}