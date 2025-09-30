import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/model/report_comment_model.dart';
import 'package:doctor_appointment_user/services/firestore_services.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:uuid/uuid.dart';
class ReportCommentController extends GetxController {
  final FirestoreServices _firestoreServices = FirestoreServices();
  var isLoading = false.obs;
  RxString reportedBy = ''.obs;
  RxString reportedTo = ''.obs;
  RxString reportReasonText = ''.obs;
  RxString contentType = ''.obs;
  RxString commentId = ''.obs;
  RxString adminId = ''.obs;
  RxString commentText = ''.obs;
  RxString postTitle = ''.obs;
  RxString commenterName = ''.obs;
  RxString commenterPhone = ''.obs;
  RxString commenterImageUrl = ''.obs;
  RxString reporterName = ''.obs;
  RxString reporterImageUrl = ''.obs;
  RxString reporterPhoneNumber = ''.obs;
  RxString postDescription = ''.obs;
  Future<void> addReport(BuildContext context) async {
    try {
      isLoading.value = true;
      ReportCommentModel model = ReportCommentModel(
        postDescription: postDescription.value.toString(),
        reporterImageurl: reporterImageUrl.value.toString(),
        reporterName: reporterName.value.toString(),
        reporterPhoneNumber: reporterPhoneNumber.value.toString(),
        commenterImageUrl: commenterImageUrl.value.toString(),
        commenterPhone: commenterPhone.value.toString(),
        commenterName: commenterName.value.toString(),
        postTitle: postTitle.value.toString(),
        commentText: commentText.value.toString(),
        adminId: adminId.value.toString(),
        reportId: Uuid().v4().toString(),
        reportReasonText: reportReasonText.value.toString(),
        reportedBy: reportedBy.value.toString(),
        reportedTo: reportedTo.value.toString(),
        contentType: contentType.value.toString(),
        commentId: commentId.value.toString(),
      );
      final createdAt = model.toMap();
      createdAt['timeStamp'] =
          FieldValue.serverTimestamp(); // Add timestamp manually
      await _firestoreServices.addReport(model, context);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
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
