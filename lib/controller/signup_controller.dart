
import 'package:doctor_appointment_user/config/routes/route_names.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_services.dart';

class SignupController extends GetxController {
  final AuthServices _authServices = AuthServices();

  var isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> registerAdmin({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    isLoading.value = true;
    final error = await _authServices.registerAdmin(name, email, password);
    isLoading.value = false;

    if (error == null) {
      FlushBarMessages.successMessageFlushBar("Registered Successfully", context);
      Navigator.pushNamed(context, RouteNames.signInRoute);
    } else {
      FlushBarMessages.errorMessageFlushBar(error.toString(), context);
      errorMessage.value = error;
    }
  }
}
