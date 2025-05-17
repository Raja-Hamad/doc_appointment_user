import 'package:doctor_appointment_user/controller/logout_controller.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:doctor_appointment_user/views/add_health_track_view.dart';
import 'package:doctor_appointment_user/views/all_appointment_booking_screen.dart';
import 'package:doctor_appointment_user/views/all_doctors_view.dart';
import 'package:doctor_appointment_user/views/all_events_view.dart';
import 'package:doctor_appointment_user/views/all_faqs_views.dart';
import 'package:doctor_appointment_user/views/all_health_tips_view.dart';
import 'package:doctor_appointment_user/views/all_invoices_view.dart';
import 'package:doctor_appointment_user/views/all_surveys_view.dart';
import 'package:doctor_appointment_user/views/allc_community_posts.dart';
import 'package:doctor_appointment_user/views/notification_view.dart';
import 'package:doctor_appointment_user/views/profile_view.dart';
import 'package:doctor_appointment_user/views/registered_events_view.dart';
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
    String? imageUrl;

  getValues() async {
    name = await localStorage.getValue("name");
    email = await localStorage.getValue("email");
    role = await localStorage.getValue("role");
        imageUrl = await localStorage.getValue("imageUrl");

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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileView()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      imageUrl!,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          fontSize: 12,
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
                    ],
                  ),
                ],
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
                leadingIcon: Icon(
                  Icons.notifications,
                  color: AppColors.primary,
                ),
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisteredEventsView(),
                  ),
                );
              },
              child: DrawerWidgetListTile(
                title: "Registered Events",
                leadingIcon: Icon(
                  Icons.app_registration,
                  color: AppColors.primary,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllHealthTipsView()),
                );
              },
              child: DrawerWidgetListTile(
                title: "Health Tips",
                leadingIcon: Icon(
                  Icons.app_registration,
                  color: AppColors.primary,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddHealthTrackView()),
                );
              },
              child: DrawerWidgetListTile(
                title: "Health Records",
                leadingIcon: Icon(
                  Icons.app_registration,
                  color: AppColors.primary,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllInvoicesView()),
                );
              },
              child: DrawerWidgetListTile(
                title: "All Invoices",
                leadingIcon: Icon(Icons.receipt_long, color: AppColors.primary),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FaqsView()),
                );
              },
              child: DrawerWidgetListTile(
                title: "All FAQs",
                leadingIcon: Icon(Icons.receipt_long, color: AppColors.primary),
              ),
            ),
               GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllSurveysView()),
                );
              },
              child: DrawerWidgetListTile(
                title: "All Surveys",
                leadingIcon: Icon(Icons.feedback, color: AppColors.primary),
              ),
            ),
              GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllCommmunityPosts()),
                );
              },
              child: DrawerWidgetListTile(
                title: "All Community Posts",
                leadingIcon: Icon(Icons.feedback, color: AppColors.primary),
              ),
            ),
                 GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllCommmunityPosts()),
                );
              },
              child: DrawerWidgetListTile(
                title: "All Feedbacks",
                leadingIcon: Icon(Icons.feedback, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 10),
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
      ),
    );
  }
}
