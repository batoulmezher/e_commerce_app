import 'package:flutter/material.dart';

class AuthTitle extends StatelessWidget {
  AuthTitle({super.key, required this.title});
  String? title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Center(
        child: Text(
          title!,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
