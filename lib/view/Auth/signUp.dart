import 'package:e_commerce_app/constant/colors.dart';
import 'package:e_commerce_app/controller/Auth/signUp_controller.dart';
import 'package:e_commerce_app/func/validInput.dart';
import 'package:e_commerce_app/view/Auth/Auth%20widget/appBarTitle.dart';
import 'package:e_commerce_app/view/Auth/Auth%20widget/authMaterialButton.dart';
import 'package:e_commerce_app/view/Auth/Auth%20widget/authSubTitle.dart';
import 'package:e_commerce_app/view/Auth/Auth%20widget/authTextFeild.dart';
import 'package:e_commerce_app/view/Auth/Auth%20widget/authTitle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (controller) => Form(
        key: controller.formstate,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 50.0),
                  child: AppParTilte(appbarTilte: 'Sign Up'),
                ),
                 AuthTitle(title: 'Register Account'),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: AuthSubTitle(
                    subtitle:
                        'Complete your details or continue\n with social media',
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, left: 10, right: 10, bottom: 10),
                  child: Authtextfeild(
                    hintText: "Enter your full name",
                    labelText: "Full Name",
                    keyboardType: TextInputType.name,
                    icon: Icons.person_outline,
                    obscureText: false,
                    mycontroller: controller.fullName,
                    validator: (val) {
                      if (val == null || val.trim().length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, left: 10, right: 10, bottom: 10),
                  child: Authtextfeild(
                    hintText: "Enter your email",
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.email_outlined,
                    obscureText: false,
                    mycontroller: controller.email,
                    validator: (val) => validInput(val!, 10, 35, 'email'),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, left: 10, right: 10, bottom: 10),
                  child: Authtextfeild(
                    hintText: "Enter your password",
                    labelText: "Password",
                    icon: controller.isShow
                        ? Icons.lock
                        : Icons.lock_open,
                    onPressed: () => controller.showPassword(),
                    obscureText: !controller.isShow,
                    mycontroller: controller.password,
                    validator: (val) =>
                        validInput(val!, 6, 30, 'password'),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, left: 10, right: 10, bottom: 10),
                  child: Authtextfeild(
                    hintText: "Re-enter your password",
                    labelText: "Confirm Password",
                    icon: controller.isShow
                        ? Icons.lock
                        : Icons.lock_open,
                    onPressed: () => controller.showPassword(),
                    obscureText: !controller.isShow,
                    mycontroller: controller.confirmPassword,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (val != controller.password!.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: controller.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : AuthGradientButton(
                          title: "Continue",
                          onPressed: () => controller.validateSignup(),
                        ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Sign In"),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, left: 18, right: 18),
                  child: const Text(
                    "By continuing you confirm that you agree\n with our Terms and Conditions",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}