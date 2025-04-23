import 'package:doctor_appointment_user/model/appointment_booking_model.dart';
import 'package:doctor_appointment_user/services/firestore_services.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:doctor_appointment_user/views/all_appointment_booking_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AppointmentBookingController extends GetxController {
  FirestoreServices firestoreServices = FirestoreServices();
  var isLoading = false.obs;

  Future<void> appointmentBooking(
    AppointmentBookingModel model,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;
      await firestoreServices.setAppointmentBooking(model, context);
      isLoading.value = false;
      FlushBarMessages.successMessageFlushBar(
        "Appointment request Sent Successfully",
        context,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AllAppointmentBookingScreen()),
      );
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print("Error while Appintment Booking ${e.toString()}");
      }
      FlushBarMessages.errorMessageFlushBar(
        "Failed to send appointment Request",
        context,
      );

      throw Exception(e.toString());
    }
  }
}
