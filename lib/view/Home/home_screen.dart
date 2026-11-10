import 'package:e_commerce_app/constant/colors.dart';
import 'package:e_commerce_app/controller/Cart/cart_controller.dart';
import 'package:e_commerce_app/controller/Home/home_controller.dart';
import 'package:e_commerce_app/view/Home/widgets/category_chip.dart';
import 'package:e_commerce_app/view/Home/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController controller = Get.put(HomeController());
  final CartController cart = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: const Text(
            'المنتجات',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            GetBuilder<CartController>(
              init: cart,
              builder: (c) => Badge(
                label: Text('${c.itemCount}'),
                isLabelVisible: c.itemCount > 0,
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.black),
                  onPressed: () => Get.toNamed('/cartScreen'),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.receipt_long_outlined,
                  color: Colors.black),
              onPressed: () => Get.toNamed('/ordersScreen'),
            ),
            IconButton(
              onPressed: controller.logout,
              icon: const Icon(Icons.logout, color: Colors.black),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildCategoriesBar(controller),
            const SizedBox(height: 8),
            Expanded(child: _buildProductsGrid(controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesBar(HomeController controller) {
    if (controller.isLoadingCategories) {
      return const SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          CategoryChip(
            label: 'All',
            isSelected: controller.selectedCategoryId == null,
            onTap: () => controller.selectCategory(null),
          ),
          ...controller.categories.map(
            (cat) => CategoryChip(
              label: cat.name,
              isSelected: controller.selectedCategoryId == cat.id,
              onTap: () => controller.selectCategory(cat.id),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(HomeController controller) {
    if (controller.isLoadingProducts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 12),
            Text('لا توجد منتجات', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount:
          controller.products.length + (controller.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= controller.products.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = controller.products[index];
        return ProductCard(
          product: product,
          onAdd: () => controller.addToCart(product),
          onTap: () => Get.toNamed(
            '/productDetails',
            arguments: product.id,
          ),
        );
      },
    );
  }
}