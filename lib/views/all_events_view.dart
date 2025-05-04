
import 'package:doctor_appointment_user/controller/events_controller.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/widgets/all_events_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class AllEventsView extends StatefulWidget {
  const AllEventsView({super.key});

  @override
  State<AllEventsView> createState() => _AllEventsViewState();
}

class _AllEventsViewState extends State<AllEventsView> {
  EventsController eventsController = Get.put(EventsController());
  @override
  void initState() {
    super.initState();
    eventsController.fetchEvents(context);
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
                "All Events",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (eventsController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                } else if (eventsController.eventsList.isEmpty) {
                  return Center(
                    child: Text(
                      "No Events yet",
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  );
                } else if (eventsController.eventsList.isNotEmpty) {
                  return AllEventsListWidget(
                    list: eventsController.eventsList,
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
