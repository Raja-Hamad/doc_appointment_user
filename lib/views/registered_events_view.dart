import 'package:doctor_appointment_user/controller/events_controller.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisteredEventsView extends StatefulWidget {
  const RegisteredEventsView({super.key});

  @override
  State<RegisteredEventsView> createState() => _RegisteredEventsViewState();
}

class _RegisteredEventsViewState extends State<RegisteredEventsView> {
  EventsController eventsController = Get.put(EventsController());
  String? currentUserId;
  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    eventsController.fetchRegisteredEventsList(currentUserId ?? "", context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Registered Events 👋",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Obx(() {
                if (eventsController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                } else if (eventsController.registeredEventsLit.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "No registered events yet",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (eventsController.registeredEventsLit.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: eventsController.registeredEventsLit.length,
                      itemBuilder: (context, index) {
                        final registeredEvent =
                            eventsController.registeredEventsLit[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Text(
                              registeredEvent.eventTitle.toString(),
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),

                                child: Image.network(
                                  registeredEvent.imageUrl.toString(),
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            subtitle: Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    registeredEvent.eventDescription.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Registered",
                                    style: GoogleFonts.poppins(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    registeredEvent.location.toString(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing:Column(
                              children: [
                                 Text(
                              registeredEvent.eventTime.toString(),
                              style: GoogleFonts.poppins(),
                            ),
                                Text(
                              registeredEvent.eventDate.toString(),
                              style: GoogleFonts.poppins(),
                            ),
                              ],
                            )
                          ),
                        );
                      },
                    ),
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
