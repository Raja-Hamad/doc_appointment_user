import 'dart:io';


import 'package:doctor_appointment_user/config/routes/route_names.dart';
import 'package:doctor_appointment_user/services/firestore_services.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_services.dart';
import 'package:intl/intl.dart';

class SignupController extends GetxController {
  final AuthServices _authServices = AuthServices();
  FirestoreServices _firestoreServices = FirestoreServices();
  var isLoading = false.obs;
  RxString errorMessage = ''.obs;
  var phoneController = TextEditingController().obs;
  var addressController = TextEditingController().obs;
  var selectedGender = "".obs;
  var selectedDob = "".obs;
  var profileImagePath = "".obs;

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDob.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  var selectedImage = Rxn<File>();

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  Future<void> registerAdmin({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String gender,
    required String dob,
    required String address,
    required File? image,
    required BuildContext context,
  }) async {
    isLoading.value = true;
    // Upload the image to Cloudinary
    String? imageUrl;
    if (image != null) {
      imageUrl = await _firestoreServices.uploadImageToCloudinary(
        image,
        context,
      );
    }
    final error = await _authServices.registerAdmin(
      name,
      email,
      password,
      phone,
      address,
      imageUrl ?? "",
      dob,
      gender,
    );
    isLoading.value = false;

    if (error == null) {
      FlushBarMessages.successMessageFlushBar(
        "Registered Successfully",
        context,
      );
      Navigator.pushNamed(context, RouteNames.signInRoute);
    } else {
      FlushBarMessages.errorMessageFlushBar(error.toString(), context);
      errorMessage.value = error;
    }
  }
}
