
import 'package:doctor_appointment_user/config/routes/route_names.dart';
import 'package:doctor_appointment_user/controller/signup_controller.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/widgets/submit_button_widget.dart';
import 'package:doctor_appointment_user/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  SignupController signupController = Get.put(SignupController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        title: Text(
          "Admin Register",
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome User 👋",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                label: "Full Name",
                controller: nameController,
                isPassword: false,
              ),
              const SizedBox(height: 16),
              TextFieldWidget(
                label: "Email Address",
                controller: emailController,
                isPassword: false,
              ),
              const SizedBox(height: 16),
              TextFieldWidget(
                label: "Password",
                controller: passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 32),
              Obx(() {
                return SubmitButtonWidget(
                  isLoading: signupController.isLoading.value,
                  buttonColor: const Color.fromRGBO(56, 177, 138, 1),
                  title: "Register",
                  onPress: () {
                    signupController.registerAdmin(
                    
                      name: nameController.text.trim().toString(),
                      email: emailController.text.trim().toString(),
                      password: passwordController.text.trim().toString(),
                      context: context,
                    );
                  },
                );
              }),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.signInRoute);
                  },
                  child: Text(
                    "Already have an account? Login",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
