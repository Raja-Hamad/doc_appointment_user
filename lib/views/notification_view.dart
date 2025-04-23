
import 'package:doctor_appointment_user/controller/notification_controller.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:doctor_appointment_user/widgets/all_notification_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  LocalStorage localStorage = LocalStorage();
  NotificationController notificationController = Get.put(
    NotificationController(),
  );

  @override
  void initState()  {
    super.initState();
    notificationController.notifications(context);
   String? userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    notificationController.markAllAsRead(userId);
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AlL Notifications 👋",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (notificationController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                } else if (notificationController.notificationList.isEmpty) {
                  return Center(child: Text("No notifications found"));
                } else if (notificationController.notificationList.isNotEmpty) {
                  return AllNotificationWidget(
                    notificationList: notificationController.notificationList,
                  );
                } else {
                  return SizedBox();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
