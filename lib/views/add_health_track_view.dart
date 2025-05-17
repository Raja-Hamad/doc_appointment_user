import 'package:doctor_appointment_user/controller/health_tracker_controller.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:doctor_appointment_user/widgets/submit_button_widget.dart';
import 'package:doctor_appointment_user/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddHealthTrackView extends StatefulWidget {
  const AddHealthTrackView({super.key});

  @override
  State<AddHealthTrackView> createState() => _AddHealthTrackViewState();
}

class _AddHealthTrackViewState extends State<AddHealthTrackView> {
  HealthTrackerController healthTrackerController = Get.put(
    HealthTrackerController(),
  );
  final List<String> moods = ['Happy', 'Neutral', 'Sad', 'Tired'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Health Tracker",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextFieldWidget(
                  controller: healthTrackerController.waterCtrl.value,
                  isPassword: false,
                  label: "Water Intake(Liters)",
                ),
                const SizedBox(height: 16),
                TextFieldWidget(
                  controller: healthTrackerController.sleepCtrl.value,
                  isPassword: false,
                  label: "Sleep(Hours)",
                ),
                const SizedBox(height: 16),
                TextFieldWidget(
                  controller: healthTrackerController.stepsCtrl.value,
                  isPassword: false,
                  label: "Steps",
                ),
                const SizedBox(height: 16),
                Text("Mood", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value:
                            healthTrackerController.mood.value.isEmpty
                                ? null
                                : healthTrackerController.mood.value,
                        hint: Text(
                          "Select Mood",
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        isExpanded: true,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        items:
                            moods.map((mood) {
                              return DropdownMenuItem<String>(
                                value: mood,
                                child: Text(mood),
                              );
                            }).toList(),
                        onChanged: (value) {
                          healthTrackerController.mood.value = value ?? '';
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SubmitButtonWidget(
                  buttonColor: AppColors.primary,
                  title: "Add Health Track",
                  onPress: () {
                    healthTrackerController.sleep.value =
                        double.tryParse(
                          healthTrackerController.sleepCtrl.value.text,
                        ) ??
                        0.0;
                    healthTrackerController.steps.value =
                        int.tryParse(
                          healthTrackerController.stepsCtrl.value.text,
                        ) ??
                        0;
                    healthTrackerController.water.value =
                        double.tryParse(
                          healthTrackerController.waterCtrl.value.text,
                        ) ??
                        0.0;
                    healthTrackerController
                        .saveLog()
                        .then((value) {
                          FlushBarMessages.successMessageFlushBar(
                            "Health Track uploaded successfully",
                            context,
                          );
                          healthTrackerController.sleepCtrl.value.clear();
                          healthTrackerController.stepsCtrl.value.clear();
                          healthTrackerController.waterCtrl.value.clear();
                          healthTrackerController.mood.value = "";
                        })
                        .onError((error, stackTrace) {
                          FlushBarMessages.errorMessageFlushBar(
                            "Error while uploading the health track ${error.toString()}",
                            context,
                          );
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
