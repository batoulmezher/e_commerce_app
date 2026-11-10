import 'package:e_commerce_app/constant/colors.dart';
import 'package:flutter/material.dart';

class AppParTilte extends StatelessWidget {
  AppParTilte({super.key, required this.appbarTilte});
  String? appbarTilte;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      title: Center(
        child: Text(
          appbarTilte!,
          style: TextStyle(
              fontSize: 17, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
