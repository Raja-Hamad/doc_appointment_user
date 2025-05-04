import 'dart:io';

import 'package:doctor_appointment_user/model/events_model.dart';
import 'package:doctor_appointment_user/services/firestore_services.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:uuid/uuid.dart';

class EventsController extends GetxController {
  var selectedImage = Rxn<File>();
  RxList<EventsModel> eventsList = <EventsModel>[].obs;
  RxList<EventsModel> registeredEventsLit = <EventsModel>[].obs;

  var isLoading = false.obs;
  FirestoreServices _firestoreServices = FirestoreServices();

  Future<List<EventsModel>> fetchEvents(BuildContext context) async {
    try {
      isLoading.value = true;
      eventsList.value = await _firestoreServices.fetchEvents(context);
      isLoading.value = false;
      FlushBarMessages.successMessageFlushBar(
        "Events Fetched Successfully",
        context,
      );
      if (kDebugMode) {
        print("All events List is ${eventsList.value}");
      }
      return eventsList;
    } catch (e) {
      isLoading.value = false;
      return [];
    }
  }

  Future<void> updateRegisterField(
    EventsModel model,
    BuildContext context,
    String currentUserId,
  ) async {
    try {
      isLoading.value = false;
      await _firestoreServices.updateRegister(model, context, currentUserId);
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

  Future<List<EventsModel>> fetchRegisteredEventsList(
    String currentUserId,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;
      registeredEventsLit.value = await _firestoreServices.getRegisteredEvents(
        currentUserId,
        context,
      );
      isLoading.value = false;
      if (kDebugMode) {
        print(
          "Total length of registered events ${registeredEventsLit.length}",
        );
        print("Registered events list is $registeredEventsLit");
      }
      return registeredEventsLit;
    } catch (e) {
      return [];
    }
  }
}
