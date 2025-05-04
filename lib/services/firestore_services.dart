import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/model/appointment_booking_model.dart';
import 'package:doctor_appointment_user/model/doctor_model.dart';
import 'package:doctor_appointment_user/model/events_model.dart';
import 'package:doctor_appointment_user/model/notification_model.dart';
import 'package:doctor_appointment_user/model/user_model.dart';
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

  // In firestore_services.dart
  Future<List<AppointmentBookingModel>> fetchUpcomingApprovedAppointments(
    BuildContext context,
  ) async {
    try {
      LocalStorage localStorage = LocalStorage();
      String? userId = await localStorage.getValue("id");

      QuerySnapshot snapshot =
          await _firestore
              .collection("appointments")
              .where("userId", isEqualTo: userId ?? "")
              .where("bookingStatus", isEqualTo: "Approved")
              .get();

      List<AppointmentBookingModel> allApprovedAppointments =
          snapshot.docs.map((doc) {
            return AppointmentBookingModel.fromJson(
              doc.data() as Map<String, dynamic>,
            );
          }).toList();

      // 🔥 Fix: Filter future dates only
      DateTime now = DateTime.now();

      List<AppointmentBookingModel> upcomingAppointments =
          allApprovedAppointments.where((appointment) {
            try {
              DateTime date = DateTime.parse(
                appointment.appointmentDate,
              ); // Safe parse from "YYYY-MM-DD"
              return date.isAfter(now) || date.isAtSameMomentAs(now);
            } catch (e) {
              print(
                "Invalid date format in appointment: ${appointment.appointmentDate}",
              );
              return false;
            }
          }).toList();

      return upcomingAppointments;
    } catch (e) {
      print("Error fetching upcoming appointments: $e");
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
          .set({...notificationModel.toMap(), "isRead": false});
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

  Future<List<UserModel>> getAllAdmins(BuildContext context) async {
    try {
      QuerySnapshot snapshot =
          await _firestore
              .collection("users")
              .where("role", isEqualTo: "admin")
              .get();
      List<UserModel> allAdmins =
          snapshot.docs
              .map(
                (json) =>
                    UserModel.fromMap(json.data() as Map<String, dynamic>),
              )
              .toList();
      FlushBarMessages.successMessageFlushBar(
        "All Admins fetched Successfully",
        context,
      );
      return allAdmins;
    } catch (e) {
      return [];
    }
  }

  Stream<QuerySnapshot> getMessages(String currentUserId, String adminId) {
    String chatRoomId = getChatRoomId(currentUserId, adminId);
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> sendMessage(
    String currentUserId,
    String adminId,
    String message,
  ) async {
    String chatRoomId = getChatRoomId(currentUserId, adminId);
    final messageData = {
      'senderId': currentUserId,
      'receiverId': adminId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(messageData);

    // Optionally update last message
    await _firestore.collection('chats').doc(chatRoomId).set({
      'lastMessage': message,
      'timestamp': FieldValue.serverTimestamp(),
      'user1': currentUserId,
      'user2': adminId,
    });
  }

  String getChatRoomId(String user1, String user2) {
    if (user1.hashCode <= user2.hashCode) {
      return "$user1\_$user2";
    } else {
      return "$user2\_$user1";
    }
  }

  Future<List<EventsModel>> fetchEvents(BuildContext context) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection("events").get();
      List<EventsModel> eventsList =
          snapshot.docs.map((json) {
            return EventsModel.fromJson(json.data() as Map<String, dynamic>);
          }).toList();
      FlushBarMessages.successMessageFlushBar(
        "Events fetched succssfully",
        context,
      );
      if (kDebugMode) {
        print("All events List in the firestore is $eventsList");
      }
      return eventsList;
    } catch (e) {
      return [];
    }
  }
}
