import 'package:e_commerce_app/routes/routes.dart';
import 'package:e_commerce_app/services/signApp_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SignUpController extends GetxController {
  bool isShow = false;
  bool isLoading = false;

  TextEditingController? email;
  TextEditingController? password;
  TextEditingController? confirmPassword; 
  TextEditingController? fullName;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  final box = GetStorage();

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
    fullName = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email!.dispose();
    password!.dispose();
    confirmPassword!.dispose();
    fullName!.dispose();
    super.dispose();
  }

  void showPassword() {
    isShow = !isShow;
    update();
  }

  Future<void> validateSignup() async {
    final form = formstate.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    await signup();
  }

Future<void> signup() async {
  try {
    isLoading = true;
    update();

    final response = await SignUpServive().postSignUpData(
      email!.text.trim(),
      password!.text,
      fullName!.text.trim(),
    );

    if (response != null) {
      if (response is Map && response['accessToken'] != null) {
        await box.write('token', response['accessToken']);
      }
      Get.snackbar(
        'نجح التسجيل',
        'تم إنشاء الحساب بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      Get.offAllNamed(AppRoutes.homeScreen);
    }
  } catch (e) {
    Get.snackbar(
      'فشل التسجيل',
      e.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading = false;
    update();
  }
}
}