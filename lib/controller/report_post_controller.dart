import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/model/report_post_model.dart';
import 'package:doctor_appointment_user/services/firestore_services.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ReportPostController extends GetxController {
  final FirestoreServices _firestoreServices = FirestoreServices();
  var isLoading = false.obs;
  RxString postReportedBy = ''.obs;
  RxString reportReasonText = ''.obs;
  RxString reportedTo = ''.obs;
  RxString contentType = ''.obs;
  RxString postId = ''.obs;
  RxString adminId = ''.obs;
  RxString postTitle = ''.obs;
  RxString postDescription = ''.obs;
  RxString reportedToUserName = ''.obs;

  Future<void> addPostReport(BuildContext context) async {
    try {
      isLoading.value = true;
      ReportPostModel reportPostModel = ReportPostModel(
        reportedToUserName: reportedToUserName.value.toString(),
        reportId: Uuid().v4().toString(),
        reportReasonText: reportReasonText.value.toString(),
        reportedTo: reportedTo.value.toString(),
        postReportedBy: postReportedBy.value.toString(),
        adminId: adminId.value.toString(),
        postDescription: postDescription.value.toString(),
        postId: postId.value.toString(),
        postTitle: postTitle.value.toString(),
        contentType: contentType.value.toString(),
      );
      final createdAt = reportPostModel.toMap();
      createdAt['timeStamp'] =
          FieldValue.serverTimestamp(); // Add timestamp manually
      await _firestoreServices.addPostReport(reportPostModel, context);
      isLoading.value = false;
    } catch (e) {
      isLoading.value=false;
      if (kDebugMode) {
        FlushBarMessages.errorMessageFlushBar(
          "Error while uploading the report ${e.toString()}",
          context,
        );
        print("Error while uplaoding the report ${e.toString()}");
        throw Exception(e.toString());
      }
    }
  }
}
