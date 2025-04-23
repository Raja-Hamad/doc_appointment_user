import 'package:doctor_appointment_user/config/routes/route_names.dart';
import 'package:doctor_appointment_user/model/user_model.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_services.dart';

class LoginController extends GetxController {
  final AuthServices _authServices = AuthServices();

  var isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> loginAdmin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    isLoading.value = true;
    final error = await _authServices.loginAdmin(email, password);
    isLoading.value = false;

    if (error == null) {
      FlushBarMessages.successMessageFlushBar("Login Successfully", context);
      Navigator.pushNamed(context, RouteNames.navBarScreenRoute);
    } else {
      errorMessage.value = error;
      FlushBarMessages.errorMessageFlushBar(error.toString(), context);
    }
  }
}

