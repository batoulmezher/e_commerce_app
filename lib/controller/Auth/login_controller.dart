import 'package:e_commerce_app/routes/routes.dart';
import 'package:e_commerce_app/services/login_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final box = GetStorage();
  final LoginService _service = LoginService();

  bool isShow = false;
  bool isLoading = false;

  TextEditingController? email;
  TextEditingController? password;

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void onDispose() {
    email?.dispose();
    password?.dispose();
  }

  void showPassword() {
    isShow = !isShow;
    update();
  }

  Future<void> validate() async {
    final form = formState.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    await login();
  }

  Future<void> login() async {
    if (isLoading) return;

    try {
      isLoading = true;
      update();

      final response = await _service.postLogInData(
        email!.text.trim(),
        password!.text,
      );

      if (response != null && response is Map && response['accessToken'] != null) {
        final token = response['accessToken'] as String;
        final user = response['user'] as Map?;

        await box.write('token', token);
        if (user != null) {
          await box.write('userId', user['id']);
          await box.write('userEmail', user['email']);
          await box.write('userName', user['fullName']);
          await box.write('userRoles', user['roles']);
        }

        print('✅ TOKEN SAVED: ${token.substring(0, 20)}...');
        print('✅ USER: ${user?['fullName']}');

        Get.snackbar(
          'مرحباً ${user?['fullName'] ?? ''}',
          'تم تسجيل الدخول بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        Get.offAllNamed(AppRoutes.homeScreen);
      } else {
        throw Exception('رد غير متوقع من السيرفر');
      }
    } catch (e) {
      Get.snackbar(
        'فشل تسجيل الدخول',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  void gotoSignup() {
    Get.toNamed(AppRoutes.signUp);
  }

 

  void rememberMeTick() {
    box.write('tick', !(box.read('tick') ?? false));
    update();
  }
}