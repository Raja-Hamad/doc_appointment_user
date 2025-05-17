import 'package:doctor_appointment_user/controller/events_controller.dart';
import 'package:doctor_appointment_user/model/events_model.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:doctor_appointment_user/views/registered_events_view.dart';
import 'package:doctor_appointment_user/widgets/submit_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class EventDetailsView extends StatefulWidget {
  EventsModel model;
  EventDetailsView({super.key, required this.model});

  @override
  State<EventDetailsView> createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {
  EventsController eventsController = Get.put(EventsController());
  String? currentUserId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.network(
                          widget.model.imageUrl ?? "",
                          fit: BoxFit.cover,
                          height: 200,
                          width: 200,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.model.eventTitle ?? "",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      widget.model.location ?? "",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "About",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.model.eventDescription ?? "",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 100),
              SubmitButtonWidget(
                buttonColor: AppColors.primary,
                title:
                    widget.model.userIds!.contains(currentUserId)
                        ? "Registered"
                        : "Register",
                onPress: () {
                  widget.model.userIds!.contains(currentUserId)
                      ? showDialog(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: Text(
                                "Event Registration",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                "Already registered for this event.",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              actions: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx); // Close dialog
                                  },
                                  child: Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 30,
                                          ),
                                          child: Text(
                                            "Ok",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      )
                      : showDialog(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: Text(
                                "Event Registration",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                "Are you sure want to register for this event?",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(ctx); // Close dialog
                                      },
                                      child: Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                  ),
                                              child: Text(
                                                "Cancel",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.pop(ctx); // Close dialog
                                        Navigator.pop(ctx);

                                        await eventsController
                                            .updateRegisterField(
                                              widget.model,
                                              ctx,
                                              currentUserId ?? "",
                                            );

                                        // Refresh doctor list
                                        await eventsController.fetchEvents(ctx);
                                        FlushBarMessages.successMessageFlushBar(
                                          "Registered for this event successfully",
                                          context,
                                        );
                                      },

                                      child: Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                  ),
                                              child: Text(
                                                "Register",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
