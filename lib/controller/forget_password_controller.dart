import 'package:doctor_appointment_user/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final AuthServices _authServices = AuthServices();
  var isLoading = false.obs;
  var emailController = TextEditingController().obs;
  Future<void> resetPassword(BuildContext context) async {
    final email = emailController.value.text.trim();
    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your email address.');
      return;
    }

    isLoading.value = true;
    try {
      await _authServices.sendPasswordResetEmail(email);
      Get.back(); // Close the bottom sheet or dialog
      Get.snackbar('Success', 'Password reset email sent.');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred.');
    } finally {
      isLoading.value = false;
    }
  }
}
