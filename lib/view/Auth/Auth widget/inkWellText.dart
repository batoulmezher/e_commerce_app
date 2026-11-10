import 'package:e_commerce_app/constant/colors.dart';
import 'package:flutter/material.dart';

class Inkwelltext extends StatelessWidget {
  Inkwelltext(
      {super.key,
      required this.FirstText,
      required this.SecondText,
      required this.onTap});
  String? FirstText;
  String? SecondText;
  void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          FirstText!,
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            SecondText!,
            style: TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
