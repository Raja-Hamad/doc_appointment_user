import 'package:doctor_appointment_user/controller/all_appointments_booking_controller.dart';
import 'package:doctor_appointment_user/utils/extensions/set_fcm_notification.dart';
import 'package:doctor_appointment_user/widgets/all_appointments_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          else if(controller.list.isEmpty){
             return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 100),
                          SvgPicture.asset("assets/svgs/nothing_found.svg"),
                          const SizedBox(height: 30),
                          Text(
                            'No appointment found.',
                            style: GoogleFonts.dmSans(
                              color: Color(0xff150B3D),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Start booking the appointments.',
                            style: GoogleFonts.openSans(
                              color: Color(0xff524B6B),
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
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
