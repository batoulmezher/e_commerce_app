
import 'package:e_commerce_app/routes/routes.dart';
import 'package:e_commerce_app/view/Auth/login_screen.dart';
import 'package:e_commerce_app/view/Auth/signUp.dart';
import 'package:e_commerce_app/view/Home/home_screen.dart';
import 'package:e_commerce_app/view/Home/product_details_screen.dart';
import 'package:e_commerce_app/view/Orders/order_details_screen.dart';
import 'package:e_commerce_app/view/Orders/orders_screen.dart';
import 'package:e_commerce_app/view/cart/cart_screen.dart';
import 'package:e_commerce_app/view/main_shell.dart';
import 'package:get/get.dart';

final pages = <GetPage>[

  
GetPage(
  name: AppRoutes.homeScreen,
  page: () => const MainShell(),
),
  GetPage(
    name: AppRoutes.login,
    page: () => LoginScreen(),
  ),
 GetPage(
    name: AppRoutes.signUp,
    page: () => SignUp(),
  ),
  GetPage(
  name: '/productDetails',
  page: () {
    final id = Get.arguments as String;
    return ProductDetailsScreen(productId: id);
  },
),
GetPage(
  name: AppRoutes.cartScreen,
  page: () => CartScreen(),
),
GetPage(
  name: AppRoutes.ordersScreen,
  page: () => OrdersScreen(),
),
GetPage(
  name: AppRoutes.orderDetails,
  page: () {
    final id = Get.arguments as String;
    return OrderDetailsScreen(orderId: id);
  },
),
 
 
 

 
  
];
