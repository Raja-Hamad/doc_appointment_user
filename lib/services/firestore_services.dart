import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/model/appointment_booking_model.dart';
import 'package:doctor_appointment_user/model/doctor_model.dart';
import 'package:doctor_appointment_user/model/notification_model.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Future<List<DoctorModel>> getDoctorsByAdminId() async {
    try {
      final adminId = currentUserId;
      if (adminId == null) return [];

      final snapshot = await _firestore.collection('doctors').get();

      return snapshot.docs
          .map((doc) => DoctorModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching doctors: $e");
      return [];
    }
  }

  Future<void> setAppointmentBooking(
    AppointmentBookingModel model,
    BuildContext context,
  ) async {
    try {
      await _firestore
          .collection("appointments")
          .doc(model.id)
          .set(model.toJson());
      FlushBarMessages.successMessageFlushBar(
        "Appointment Request Sent Successully",
        context,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error while booking Appointment is ${e.toString()}");
      }
      FlushBarMessages.errorMessageFlushBar(
        "Failed to send appointment Request",
        context,
      );

      throw Exception("Error while Uploading appointment ${e.toString()}");
    }
  }

  Future<List<AppointmentBookingModel>> fetchList(BuildContext context) async {
    try {
      LocalStorage localStorage = LocalStorage();
      String? userId = await localStorage.getValue("id");

      QuerySnapshot snapshot =
          await _firestore
              .collection("appointments")
              .where("userId", isEqualTo: userId ?? "")
              .get();
      FlushBarMessages.successMessageFlushBar(
        "Appointments List fecthed Successfully",
        context,
      );
      List<AppointmentBookingModel> appointmentList =
          snapshot.docs.map((doc) {
            return AppointmentBookingModel.fromJson(
              doc.data() as Map<String, dynamic>,
            );
          }).toList();
      return appointmentList;
    } catch (e) {
      if (kDebugMode) {
        print("Error while fetching appointments list ${e.toString()}");
      }
      FlushBarMessages.errorMessageFlushBar(
        "Error while Fetching the appointment list",
        context,
      );
      return [];
    }
  }

  Future<void> uploadNotification(
    NotificationModel notificationModel,
    BuildContext context,
  ) async {
    try {
      await _firestore
          .collection("notifications")
          .doc(notificationModel.id)
          .set({
            ... notificationModel.toMap(),
            "isRead":false
          });
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
      LocalStorage localStorage = LocalStorage();
      String? userId = await localStorage.getValue("id");
      QuerySnapshot snapshot =
          await _firestore
              .collection("notifications")
              .where("userId", isEqualTo: userId ?? "")
              .get();

      List<NotificationModel> notificationList =
          snapshot.docs.map((doc) {
            return NotificationModel.fromJson(
              doc.data() as Map<String, dynamic>,
            );
          }).toList();
      FlushBarMessages.successMessageFlushBar(
        "Notification FetchedSuccessfully",
        context,
      );
      return notificationList;
    } catch (e) {
      return [];
    }
  }
}
