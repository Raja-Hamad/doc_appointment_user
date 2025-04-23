import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/model/notification_model.dart';
import 'package:doctor_appointment_user/services/firestore_services.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController{
  
    List<NotificationModel> notificationList = <NotificationModel>[].obs;

  var isLoading = false.obs;
  final FirestoreServices _firestoreService = FirestoreServices();
  Future<void> uploadNotification(
    NotificationModel model,
    BuildContext context,
  ) async {
    try {
      await _firestoreService.uploadNotification(model, context);
      FlushBarMessages.successMessageFlushBar(
        "Notification Uploaded Successfully",
        context,
      );
    } catch (e) {
      if (kDebugMode) {
        FlushBarMessages.errorMessageFlushBar(
          "Error while uploading the notification ${e.toString()}",
          context,
        );
        print("Error while uploading Notfication ${e.toString()}");
        throw Exception(e.toString());
      }
    }
  }

  Future<List<NotificationModel>> notifications(BuildContext context) async {
    try {
      isLoading.value = true;
      notificationList = await _firestoreService.notifications(context);
      FlushBarMessages.successMessageFlushBar(
        "Notification List Fetched Successfully",
        context,
      );
      isLoading.value = false;
      if(kDebugMode){
        print("Notifications are $notificationList");
      }
      return notificationList;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print("Error while fetching the notification List ${e.toString()}");
        FlushBarMessages.errorMessageFlushBar(
          "Error while Fetching the Notification List ${e.toString()}",
          context,
        );
      }
      return [];
    }
  }
   var hasUnreadNotifications = false.obs;

  void listenForUnreadNotifications(String adminId) {
    FirebaseFirestore.instance
        .collection("notifications")
        .where("adminId", isEqualTo: adminId)
        .where("isRead", isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      hasUnreadNotifications.value = snapshot.docs.isNotEmpty;
    });
  }

  Future<void> markAllAsRead(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("notifications")
        .where("adminId", isEqualTo: userId)
        .where("isRead", isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }


}