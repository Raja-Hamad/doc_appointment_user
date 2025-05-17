import 'package:doctor_appointment_user/model/appointment_booking_model.dart';
import 'package:doctor_appointment_user/services/firestore_services.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AllAppointmentsBookingController extends GetxController {
  RxMap<DateTime, List<AppointmentBookingModel>> calendarEvents =
      <DateTime, List<AppointmentBookingModel>>{}.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<AppointmentBookingModel> selectedAppointments =
      <AppointmentBookingModel>[].obs;
  var isLoading = false.obs;
  List<AppointmentBookingModel> list = <AppointmentBookingModel>[].obs;
  List<AppointmentBookingModel> upcomingAppointmentsList =
      <AppointmentBookingModel>[].obs;
  FirestoreServices services = FirestoreServices();

  var isUpcomingAppointmentLoading = false.obs;

  Future<List<AppointmentBookingModel>> getAllAppointments(
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;
      list = await services.fetchList(context);
      isLoading.value = false;
      FlushBarMessages.successMessageFlushBar(
        "Appointments List fetched Successfully",
        context,
      );
      if (kDebugMode) {
        print("ALL appointments List is $list");
      }
      return list;
    } catch (e) {
      isLoading.value = false;
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

  void fetchUpcomingApprovedAppointmentsMethod(BuildContext context) async {
    isLoading.value = true;
    final appointments = await services.fetchUpcomingApprovedAppointments(
      context,
    );

  
    isLoading.value = false;
  }
  void onDaySelected(DateTime selected, DateTime focused) {
  final day = DateTime(selected.year, selected.month, selected.day);
  selectedDate.value = day;
  selectedAppointments.value = calendarEvents[day] ?? [];
}

}
