import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/authentication/login_screen.dart';
import 'package:doctor_appointment_user/controller/all_doctors_controller.dart';
import 'package:doctor_appointment_user/model/doctor_model.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:doctor_appointment_user/views/doctor_details_view.dart';
import 'package:doctor_appointment_user/widgets/drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AllDoctorsView extends StatefulWidget {
  const AllDoctorsView({super.key});

  @override
  State<AllDoctorsView> createState() => _AllDoctorsViewState();
}

class _AllDoctorsViewState extends State<AllDoctorsView> {
  final AllDoctorsController allDoctorsController = Get.put(
    AllDoctorsController(),
  );
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    allDoctorsController.fetchDoctors();
    getValues();
  }

 LocalStorage localStorage = LocalStorage();
  String? name;
  String? email;
  String? role;
  String? adminDeviceToken;
  String? phone;

  String? imageUrl;



  getValues() async {
    name = await localStorage.getValue("userName");
    email = await localStorage.getValue("email");
    role = await localStorage.getValue("role");
    imageUrl = await localStorage.getValue("imageUrl");
    phone = await localStorage.getValue("phone");
    adminDeviceToken = await localStorage.getValue("userDeviceToken");
    if (kDebugMode) {
      print("Device Token of the admin is ${adminDeviceToken ?? ""}");
    }

    setState(() {});
  }

  Future<void> logout() async {
    // Step 1: local storage clear karo
    await localStorage.clear("id");
    await localStorage.clear("name");

    await localStorage.clear("imageUrl");

    await localStorage.clear("phone");

    await localStorage.clear("role");

    await localStorage.clear("email");

    await localStorage.clear("userDeviceToken");

    await localStorage.clear("address");

    await localStorage.clear("gender");

    await localStorage.clear("dob");
    

    await FirebaseAuth.instance.signOut();

    // Step 3: Navigate back to SplashView (stack clear)
    Get.offAll(() => LoginScreen());
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: AppColors.background,
      drawer: Drawer(child: DrawerWidget()),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            globalKey.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu, color: Colors.black),
        ),
        backgroundColor: AppColors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          "Doctors",
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection("doctors").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              } else {
                final doctorsList =
                    snapshot.data!.docs
                        .map(
                          (json) => DoctorModel.fromMap(
                            json.data() as Map<String, dynamic>,
                          ),
                        )
                        .toList();
                return ListView.separated(
                  itemCount: doctorsList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doctor = doctorsList[index];

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Doctor image
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                doctor.imageUrl != null
                                    ? NetworkImage(doctor.imageUrl)
                                    : const AssetImage(
                                          'assets/images/avatar_placeholder.png',
                                        )
                                        as ImageProvider,
                            backgroundColor: Colors.grey[200],
                          ),
                          const SizedBox(width: 16),

                          // Doctor details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.name ?? 'No Name',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  doctor.specialization ?? 'No Specialization',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DoctorDetailsView(
                                        doctorModel: doctor,
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Book Appointment",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    // Action buttons
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
