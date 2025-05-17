import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/model/health_tracker_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class HealthTrackerController extends GetxController {
  RxDouble water = 0.0.obs;
  RxDouble sleep = 0.0.obs;
  RxInt steps = 0.obs;
  RxString mood = ''.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  var waterCtrl = TextEditingController().obs;
  var sleepCtrl = TextEditingController().obs;
  var stepsCtrl = TextEditingController().obs;

  Future<void> saveLog() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    HealthTrackerModel healthTrackerModel = HealthTrackerModel(
      waterIntake: water.value,
      sleep: sleep.value,
      steps: steps.value,
      uid: uid.toString(),
      id: Uuid().v4(),
      today: today.toString(),
      mood: mood.value,
    );
    // ✅ Inject server timestamp at write time
    final data = healthTrackerModel.toJson();
    data['createdAt'] = FieldValue.serverTimestamp(); // Add timestamp manually
    await FirebaseFirestore.instance
        .collection('health_tracker')
        .doc(uid.toString())
        .collection('user_entries')
        .add(data); // ✅ Use the modified data
  }

  Stream<DocumentSnapshot> getTodayLog() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return _firestore
        .collection('health_tracker')
        .doc(uid)
        .collection('logs')
        .doc(today)
        .snapshots();
  }
}
