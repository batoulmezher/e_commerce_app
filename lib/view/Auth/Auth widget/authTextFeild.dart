import 'package:e_commerce_app/constant/colors.dart';
import 'package:flutter/material.dart';

class Authtextfeild extends StatelessWidget {
  String? hintText;
  String? labelText;
  IconData? icon;
  void Function()? onPressed;
  bool obscureText = false;
  TextEditingController? mycontroller;
  TextInputType? keyboardType = TextInputType.text;
  String? Function(String?)? validator;
  void Function(String?)? onSaved;

  Authtextfeild({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.icon,
    required this.obscureText,
    this.onPressed,
    this.keyboardType,
    required this.mycontroller,
    required this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      controller: mycontroller,
      cursorColor: AppColors.primary,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: 18.0, horizontal: 30.0),
        isDense: true,

        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: Colors.grey,
            size: 25,
          ),
        ),
       

        hintText: hintText,
        labelText: labelText,

        floatingLabelBehavior: FloatingLabelBehavior.always,

        labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
