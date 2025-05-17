import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/model/appointment_booking_model.dart';
import 'package:doctor_appointment_user/model/comment_model.dart';
import 'package:doctor_appointment_user/model/doctor_model.dart';
import 'package:doctor_appointment_user/model/events_model.dart';
import 'package:doctor_appointment_user/model/feedback_model.dart';
import 'package:doctor_appointment_user/model/invoice_model.dart';
import 'package:doctor_appointment_user/model/notification_model.dart';
import 'package:doctor_appointment_user/model/report_comment_model.dart';
import 'package:doctor_appointment_user/model/report_post_model.dart';
import 'package:doctor_appointment_user/model/user_model.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

      return allApprovedAppointments;
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

  Future<void> updateRegister(
    EventsModel model,
    BuildContext context,
    String currentUserId,
  ) async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection("events")
          .doc(model.id ?? "");

      // Use arrayUnion to safely add without duplicates
      await docRef.update({
        "userIds": FieldValue.arrayUnion([currentUserId]),
      });
    } catch (e) {
      if (kDebugMode) {
        FlushBarMessages.errorMessageFlushBar(
          "Error while Registering for the event ${e.toString()}",
          context,
        );
        print("Error while Registering for the event ${e.toString()}");
        throw Exception(e.toString());
      }
    }
  }

  Future<List<EventsModel>> getRegisteredEvents(
    String currentUserId,
    BuildContext context,
  ) async {
    try {
      QuerySnapshot snapshot =
          await _firestore
              .collection("events")
              .where("userIds", arrayContains: currentUserId)
              .get();
      List<EventsModel> list =
          snapshot.docs
              .map(
                (json) =>
                    EventsModel.fromJson(json.data() as Map<String, dynamic>),
              )
              .toList();
      return list;
    } catch (e) {
      return [];
    }
  }

  Stream<List<InvoiceModel>> getInvoicesStream(String userId) {
    return _firestore
        .collection("invoices")
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return InvoiceModel.fromJson(doc.data() as Map<String, dynamic>);
          }).toList();
        });
  }

  Future<String> uploadImageToCloudinary(
    File imageFile,
    BuildContext context,
  ) async {
    final cloudName = 'dqs1y6urv'; // Replace with your Cloudinary Cloud Name
    final apiKey = '463369248646777'; // Replace with your Cloudinary API Key
    final preset =
        'ecommerce_preset'; // Replace with your Cloudinary Upload Preset

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = preset
          ..files.add(
            await http.MultipartFile.fromPath('file', imageFile.path),
          );

    final response = await request.send();
    if (response.statusCode == 200) {
      FlushBarMessages.successMessageFlushBar(
        "Image Uploaded Successfully",
        context,
      );
      final res = await http.Response.fromStream(response);
      final data = jsonDecode(res.body);
      return data['secure_url']; // Image URL from Cloudinary
    } else {
      FlushBarMessages.errorMessageFlushBar("Failed to upload Image", context);
      throw Exception('Failed to upload image to Cloudinary');
    }
  }

  Future<void> uploadReponse(
    Map<String, dynamic> data,
    String questionId,
    String surveyId,
    BuildContext context,
  ) async {
    try {
      await _firestore.collection("survey_questions").doc(questionId).update({
        "answersList": FieldValue.arrayUnion([data]),
      });
    } catch (e) {
      if (kDebugMode) {
        FlushBarMessages.errorMessageFlushBar(
          "Error while uploading the response ${e.toString()}",
          context,
        );
        print("Error while uplaoding the response ${e.toString()}");
        throw Exception(e.toString());
      }
    }
  }

  Future<void> addComment(CommentModel model, BuildContext context) async {
    try {
      await _firestore
          .collection("comments")
          .doc(model.commentId!)
          .set(model.toMap());
      FlushBarMessages.successMessageFlushBar(
        "Successfully uploaded the comment",
        context,
      );
    } catch (e) {
      if (kDebugMode) {
        FlushBarMessages.errorMessageFlushBar(
          "Error while uploading the comment ${e.toString()}",
          context,
        );
        print("Error while uplaoding the comment ${e.toString()}");
        throw Exception(e.toString());
      }
    }
  }

  Future<void> addReport(ReportCommentModel model, BuildContext context) async {
    try {
      await _firestore
          .collection("reported_comments")
          .doc(model.reportId!)
          .set(model.toMap());
      FlushBarMessages.successMessageFlushBar(
        "Report added successfully",
        context,
      );
    } catch (e) {
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

  Future<void> deleteComment(String commentId, BuildContext context) async {
    try {
      await _firestore.collection("comments").doc(commentId).delete();
    } catch (e) {
      if (kDebugMode) {
        FlushBarMessages.errorMessageFlushBar(
          "Error while delelting the comment ${e.toString()}",
          context,
        );
        print("Error while deleting the comment ${e.toString()}");
        throw Exception(e.toString());
      }
    }
  }

  Future<void> addPostReport(
    ReportPostModel model,
    BuildContext context,
  ) async {
    try {
      await _firestore
          .collection("reported_posts")
          .doc(model.reportId!)
          .set(model.toMap());
      FlushBarMessages.successMessageFlushBar(
        "Report added successfully",
        context,
      );
    } catch (e) {
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

  final String _collection = "feedback";

  Future<void> submitFeedback(
    String question,
    FeedbackResponseModel response,
  ) async {
    // 1. Get a reference to the 'masterFeedback' document inside the 'feedback' collection
    final feedbackDoc = _firestore
        .collection(_collection)
        .doc("masterFeedback");

    // 2. Get the current snapshot (data) of that document
    final docSnapshot = await feedbackDoc.get();

    if (docSnapshot.exists) {
      // 3. If the document exists, read the 'feedback' list (or an empty list if not found)
      List<dynamic> feedbackList = docSnapshot.data()?['feedback'] ?? [];

      // 4. Look inside the list to find the index of the question that matches the provided question
      int index = feedbackList.indexWhere(
        (f) => f['questionStatement'] == question,
      );

      if (index != -1) {
        // 5. If the question already exists, add the new user's response to the 'responses' list of that question
        feedbackList[index]['responses'].add(response.toMap());
      } else {
        // 6. If the question doesn't exist, add a new question object with the user's response
        feedbackList.add({
          'questionStatement': question,
          'responses': [response.toMap()],
        });
      }

      // 7. Update the document in Firestore with the updated feedback list
      await feedbackDoc.update({'feedback': feedbackList});
    } else {
      // 8. If the document itself doesn't exist, create it with a feedback list that includes this new question and response
      await feedbackDoc.set({
        'feedback': [
          {
            'questionStatement': question,
            'responses': [response.toMap()],
          },
        ],
      });
    }
  }
}
