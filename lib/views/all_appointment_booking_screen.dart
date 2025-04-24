import 'package:doctor_appointment_user/controller/all_appointments_booking_controller.dart';
import 'package:doctor_appointment_user/model/appointment_booking_model.dart';
import 'package:doctor_appointment_user/utils/extensions/set_fcm_notification.dart';
import 'package:doctor_appointment_user/widgets/all_appointments_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

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

                /// Table Calendar
                TableCalendar<AppointmentBookingModel>(
                  firstDay: DateTime.now().subtract(const Duration(days: 365)),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: controller.selectedDate.value,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarFormat: CalendarFormat.month,
                  eventLoader: (day) {
                    final d = DateTime(day.year, day.month, day.day);
                    return controller.calendarEvents[d] ?? [];
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(controller.selectedDate.value, day);
                  },
                  onDaySelected: controller.onDaySelected,
                  calendarStyle: const CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Selected Appointments for the Day
                if (controller.selectedAppointments.isNotEmpty) ...[
                  Text(
                    "Appointments on ${controller.selectedDate.value.toLocal().toString().split(' ')[0]}",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...controller.selectedAppointments.map((appt) => Card(
                        child: ListTile(
                          title: Text(appt.doctorName),
                          subtitle: Text("${appt.appointmentTime}"),
                        ),
                      )),
                ] else
                  Text(
                    "No Appointments on selected date.",
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),

                const SizedBox(height: 24),

                /// All Appointments List
                Text(
                  "All Appointments",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                /// Pass the full list to widget (not Expanded anymore)
                AllAppointmentsWidget(allAppointments: controller.list),
              ],
            ),
          );
        }),
      ),
    );
  }
}
