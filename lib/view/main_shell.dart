import 'package:e_commerce_app/controller/Cart/cart_controller.dart';
import 'package:e_commerce_app/view/Cart/cart_screen.dart';
import 'package:e_commerce_app/view/Home/home_screen.dart';
import 'package:e_commerce_app/view/Orders/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final CartController cart = Get.find<CartController>();

  final List<Widget> _pages = [
    HomeScreen(),
    CartScreen(),
    OrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: GetBuilder<CartController>(
  init: cart,
  builder: (c) => NavigationBar(
    selectedIndex: _currentIndex,
    onDestinationSelected: (i) => setState(() => _currentIndex = i),
    backgroundColor: Colors.white,
    destinations: [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'الرئيسية',
      ),
      NavigationDestination(
        icon: Badge(
          label: Text('${c.itemCount}'),
          isLabelVisible: c.itemCount > 0,
          child: const Icon(Icons.shopping_cart_outlined),
        ),
        selectedIcon: const Icon(Icons.shopping_cart),
        label: 'السلة',
      ),
      const NavigationDestination(
        icon: Icon(Icons.receipt_long_outlined),
        selectedIcon: Icon(Icons.receipt_long),
        label: 'طلباتي',
      ),
    ],
  ),
),
    );
  }
}