import 'package:doctor_appointment_user/config/routes/route_names.dart';
import 'package:doctor_appointment_user/services/auth_services.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LogoutController extends GetxController {
  AuthServices authServices = AuthServices();
  LocalStorage localStorage = LocalStorage();
  var isLoggingOut = false.obs;

  Future<void> logoutUser(BuildContext context) async {
    try {
      isLoggingOut.value = true;

      // Firebase Sign Out
      await authServices.logout();
      isLoggingOut.value=false;
      await localStorage.clear("name");
      await localStorage.clear("email");
      await localStorage.clear("userDeviceToken");
      await localStorage.clear("id");
      await localStorage.clear("role");

      // Clear Shared Preferences / Local Storage

      // Navigate to login screen
      Navigator.pushNamed(context, RouteNames.signInRoute);
    } catch (e) {
      Get.snackbar("Logout Failed", e.toString());
    } finally {
      isLoggingOut.value = false;
    }
  }
}
