import 'package:doctor_appointment_user/controller/notification_controller.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/views/all_appointment_booking_screen.dart';
import 'package:doctor_appointment_user/views/all_doctors_view.dart';
import 'package:doctor_appointment_user/views/notification_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  NotificationController notificationController = Get.put(
    NotificationController(),
  );
  List<Widget> screens = [
    AllDoctorsView(),
    AllAppointmentBookingScreen(),
    NotificationView(),
  ];

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      backgroundColor: AppColors.primary,
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: GoogleFonts.poppins(color: Colors.white),
        unselectedLabelStyle: GoogleFonts.poppins(color: Colors.white),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: "Doctors",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Appointments",
          ),
          BottomNavigationBarItem(
            icon: Obx(() {
              return Badge(
                largeSize: 20,
                isLabelVisible:
                    notificationController.hasUnreadNotifications.value,
                child: Icon(Icons.notifications),
              );
            }),
            label: "Notifications",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String? adminId = FirebaseAuth.instance.currentUser?.uid;

    if (adminId != null) {
      Get.put(NotificationController()).listenForUnreadNotifications(adminId);
    }
  }
}
