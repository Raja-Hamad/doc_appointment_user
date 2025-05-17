
import 'package:doctor_appointment_user/config/routes/route_names.dart';
import 'package:doctor_appointment_user/controller/forget_password_controller.dart';
import 'package:doctor_appointment_user/controller/login_controller.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/widgets/forget_password_bottom_sheet.dart';
import 'package:doctor_appointment_user/widgets/submit_button_widget.dart';
import 'package:doctor_appointment_user/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    ForgetPasswordController forgetPasswordController = Get.put(
    ForgetPasswordController(),
  );
  LoginController loginController = Get.put(LoginController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        title: Text(
          "Login",
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back 👋",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              controller: emailController,
              isPassword: false,
              label: "Email Address",
            ),
            const SizedBox(height: 16),
            TextFieldWidget(
              controller: passwordController,
              isPassword: true,
              label: "Password",
            ),
               const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    isScrollControlled: true,
                    backgroundColor: AppColors.white,
                    builder:
                        (_) => ForgetPasswordBottomSheet(
                          controller:
                              forgetPasswordController.emailController.value,
                          title: "Forget Password",
                          buttonText: "Reset Password",
                          onSubmit: () {
                            forgetPasswordController.resetPassword(context);
                            // Call your reset method here
                          },
                        ),
                  );
                },

                child: Text(
                  "Forget Password?",
                  style: GoogleFonts.poppins(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Obx(() {
              return SubmitButtonWidget(
                isLoading: loginController.isLoading.value,
                buttonColor: AppColors.primary,
                title: "Login",
                onPress: () {
                  loginController.loginAdmin(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    context: context,
                  );
                },
              );
            }),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate to Register Screen
                },
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.signUpRoute);
                  },
                  child: Text(
                    "Don't have an account? Register",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
