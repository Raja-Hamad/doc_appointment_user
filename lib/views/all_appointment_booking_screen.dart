import 'package:doctor_appointment_user/controller/all_appointments_booking_controller.dart';
import 'package:doctor_appointment_user/utils/extensions/set_fcm_notification.dart';
import 'package:doctor_appointment_user/widgets/all_appointments_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AllAppointmentBookingScreen extends StatefulWidget {
  const AllAppointmentBookingScreen({super.key});

  @override
  State<AllAppointmentBookingScreen> createState() =>
      _AllAppointmentBookingScreenState();
}

class _AllAppointmentBookingScreenState
    extends State<AllAppointmentBookingScreen> {
  AllAppointmentsBookingController controller =
      Get.put(AllAppointmentsBookingController());

  @override
  void initState() {
    super.initState();
    controller.getAllAppointments(context);
    controller.fetchUpcomingApprovedAppointmentsMethod(context);
    SetFcmNotifications.setupFCMNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Text(
                  "All Appointments 👋",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

             
                AllAppointmentsWidget(allAppointments: controller.list),
              ],
            ),
          );
        }),
      ),
    );
  }
}
