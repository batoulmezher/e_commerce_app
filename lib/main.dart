import 'package:e_commerce_app/controller/Cart/cart_controller.dart';
import 'package:e_commerce_app/routes/pages.dart';
import 'package:e_commerce_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();  
  Get.put(CartController(), permanent: true); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(       
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      getPages: pages,
    );
  }
}