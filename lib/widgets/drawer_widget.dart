import 'package:doctor_appointment_user/controller/logout_controller.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:doctor_appointment_user/views/all_appointment_booking_screen.dart';
import 'package:doctor_appointment_user/views/all_doctors_view.dart';
import 'package:doctor_appointment_user/views/all_events_view.dart';
import 'package:doctor_appointment_user/views/notification_view.dart';
import 'package:doctor_appointment_user/views/profile_view.dart';
import 'package:doctor_appointment_user/widgets/drawer_widget_tist_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  LogoutController logoutController = Get.put(LogoutController());
  LocalStorage localStorage = LocalStorage();
  String? name;
  String? email;
  String? role;
  getValues() async {
    name = await localStorage.getValue("name");
    email = await localStorage.getValue("email");
    role = await localStorage.getValue("role");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name ?? "",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            email ?? "",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            role ?? "",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllDoctorsView()),
              );
            },
            child: DrawerWidgetListTile(
              title: "All Doctors",
              leadingIcon: Icon(Icons.person, color: AppColors.primary),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllAppointmentBookingScreen(),
                ),
              );
            },
            child: DrawerWidgetListTile(
              title: "All Appointments",
              leadingIcon: Icon(Icons.book, color: AppColors.primary),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationView()),
              );
            },
            child: DrawerWidgetListTile(
              title: "All Notfications",
              leadingIcon: Icon(Icons.notifications, color: AppColors.primary),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileView()),
              );
            },
            child: DrawerWidgetListTile(
              title: "Profile",
              leadingIcon: Icon(Icons.person, color: AppColors.primary),
            ),
          ),
           GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllEventsView()),
              );
            },
            child: DrawerWidgetListTile(
              title: "Events",
              leadingIcon: Icon(Icons.event, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 40),
          Obx(() {
            return DrawerWidgetListTile(
              isLoading: logoutController.isLoggingOut.value,
              onPress: () {
                logoutController.logoutUser(context);
              },

              leadingIcon: Icon(Icons.logout, color: AppColors.primary),
              title: "Logout",
            );
          }),
        ],
      ),
    );
  }
}
