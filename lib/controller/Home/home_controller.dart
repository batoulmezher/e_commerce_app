import 'package:e_commerce_app/modules/category_model.dart';
import 'package:e_commerce_app/modules/product_model.dart';
import 'package:e_commerce_app/services/home_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final HomeService _service = HomeService();
  final box = GetStorage();

  // --- Categories ---
  List<CategoryModel> categories = [];
  bool isLoadingCategories = true;

  // --- Products ---
  List<ProductModel> products = [];
  bool isLoadingProducts = true;
  bool isLoadingMore = false;

  // --- Filter + Pagination ---
  String? selectedCategoryId; 
  int page = 1;
  int pageSize = 20;
  int totalPages = 1;

  // --- UI ---
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadProducts(reset: true);
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // -------- Load Data --------
  Future<void> loadCategories() async {
    isLoadingCategories = true;
    update();
    categories = await _service.getCategories();
    isLoadingCategories = false;
    update();
  }

  Future<void> loadProducts({bool reset = true}) async {
    if (reset) {
      page = 1;
      products.clear();
      isLoadingProducts = true;
    } else {
      isLoadingMore = true;
    }
    update();

    final result = await _service.getProducts(
      categoryId: selectedCategoryId, 
      page: page,
      pageSize: pageSize,
    );

    final List items = (result['items'] ?? []) as List;
    products.addAll(items.cast<ProductModel>());

    totalPages = (result['totalPages'] as int?) ?? 0;
    isLoadingProducts = false;
    isLoadingMore = false;
    update();
  }

  void selectCategory(String? categoryId) {
    if (selectedCategoryId == categoryId) return;
    selectedCategoryId = categoryId;
    loadProducts(reset: true);
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore && page < totalPages) {
        page++;
        loadProducts(reset: false);
      }
    }
  }

  void addToCart(ProductModel product) {
    if (product.stock <= 0) {
      Get.snackbar('نفد المخزون', 'هذا المنتج غير متوفر حالياً',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    Get.snackbar('تنبيه', 'افتحي المنتج لتحديد الكمية',
        backgroundColor: Colors.orange, colorText: Colors.white);
  }

  void logout() {
    box.remove('token');
    Get.offAllNamed('/loginScreen');
  }
}