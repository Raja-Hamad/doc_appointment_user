
import 'package:doctor_appointment_user/config/routes/route_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileController extends GetxController {
  var textEditingControllerEmail = TextEditingController().obs;
  var textEditingControllerName = TextEditingController().obs;
  var isLoading = false.obs;

  Future<void> updateProfile(String newEmail, String newName, BuildContext context) async {
    try {
      isLoading.value = true;

      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        Get.snackbar("Error", "User not logged in.");
        return;
      }

      // Re-authenticate the user if needed (this depends on your app flow)

      // 🔄 Step 1: Update email in Firebase Authentication
      if (currentUser.email != newEmail) {
        await currentUser.verifyBeforeUpdateEmail(newEmail);
      }

      // ✅ Step 2: Update Firestore user info
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'email': newEmail,
        'name': newName,
      });

      // ✅ Step 3: Remove from local storage (already done by you)
      // ✅ Step 4: Navigate to login screen
Navigator.pushNamed(context, RouteNames.signInRoute);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
