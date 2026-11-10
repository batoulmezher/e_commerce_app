import 'package:e_commerce_app/constant/colors.dart';
import 'package:e_commerce_app/controller/Auth/login_controller.dart';
import 'package:e_commerce_app/func/validInput.dart';
import 'package:e_commerce_app/view/Auth/Auth%20widget/appBarTitle.dart';
import 'package:e_commerce_app/view/Auth/Auth%20widget/authMaterialButton.dart';
import 'package:e_commerce_app/view/Auth/Auth%20widget/authSubTitle.dart';
import 'package:e_commerce_app/view/Auth/Auth%20widget/authTextFeild.dart';
import 'package:e_commerce_app/view/Auth/Auth%20widget/authTitle.dart';
import 'package:e_commerce_app/view/Auth/Auth%20widget/inkWellText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) => Form(
        key: controller.formState,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                 AppParTilte(appbarTilte: "Sign in"),
                 AuthTitle(title: "Welcome Back"),
                 Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: AuthSubTitle(
                    subtitle:
                        "Sign in with your email and password \n or continue with social media",
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, left: 10, right: 10, bottom: 10),
                  child: Authtextfeild(
                    validator: (val) => validInput(val!, 10, 40, "email"),
                    mycontroller: controller.email,
                    hintText: "Enter your Email",
                    labelText: "Email",
                    icon: Icons.email_outlined,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, left: 10, right: 10, bottom: 10),
                  child: Authtextfeild(
                    validator: (val) => validInput(val!, 5, 20, 'password'),
                    mycontroller: controller.password!,
                    hintText: "Enter your Password",
                    labelText: "Password",
                    icon: controller.isShow
                        ? Icons.lock_outline
                        : Icons.lock_open_outlined,
                    onPressed: () => controller.showPassword(),
                    obscureText: !controller.isShow,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),

                // Remember me + Forget Password
                Row(
  children: [
    Checkbox(
      checkColor: AppColors.primary,
      activeColor: AppColors.background,
      value: controller.box.read("tick") ?? false,
      onChanged: (_) => controller.rememberMeTick(),
    ),
    const Text(
      "Remember me",
      style: TextStyle(fontWeight: FontWeight.w500),
    ),
    const Spacer(),
  
  ],
),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: controller.isLoading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : AuthGradientButton(
                          title: "Continue",
                          onPressed: () => controller.validate(),
                        ),
                ),

                const SizedBox(height: 20),

                Inkwelltext(
                  FirstText: "Dont have an account?",
                  SecondText: "  Sign Up",
                  onTap: () => controller.gotoSignup(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}