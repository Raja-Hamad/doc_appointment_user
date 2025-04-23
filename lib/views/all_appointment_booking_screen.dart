import 'package:doctor_appointment_user/controller/all_appointments_booking_controller.dart';
import 'package:doctor_appointment_user/widgets/all_appointments_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class AllAppointmentBookingScreen extends StatefulWidget {
  const AllAppointmentBookingScreen({super.key});

  @override
  State<AllAppointmentBookingScreen> createState() =>
      _AllAppointmentBookingScreenState();
}

class _AllAppointmentBookingScreenState
    extends State<AllAppointmentBookingScreen> {
  AllAppointmentsBookingController controller = Get.put(
    AllAppointmentsBookingController(),
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getAllAppointments(context);
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
                "All Appointments 👋",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                } else if (controller.list.isEmpty) {
                  return Center(
                    child: Text(
                      "No Appointments Yet. Create One",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                  );
                } else if (controller.list.isNotEmpty) {
                  return AllAppointmentsWidget(
                    allAppointments: controller.list,
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
