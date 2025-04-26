import 'package:doctor_appointment_user/model/user_model.dart';
import 'package:doctor_appointment_user/services/firestore_services.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FetchAllAdminsController extends GetxController {
  var isLoading = false.obs;
  RxList<UserModel> allAdmins = <UserModel>[].obs;
  FirestoreServices _firestoreServices = FirestoreServices();
  Future<List<UserModel>> allAdminsList(BuildContext context) async {
    try {
      allAdmins.value = await _firestoreServices.getAllAdmins(context);
      FlushBarMessages.successMessageFlushBar(
        "All Amins Fetched Successfully",
        context,
      );
      if(kDebugMode){
        print("All Admins are $allAdmins");
        print("Total Admins ${allAdmins.length}");
      }
      return allAdmins;
    } catch (e) {
      return [];
    }
  }
}
