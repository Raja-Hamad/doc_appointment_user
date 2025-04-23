
import 'package:doctor_appointment_user/controller/all_doctors_controller.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/widgets/all_doctors_widgets.dart';
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

  @override
  void initState() {
    super.initState();
    allDoctorsController.fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      backgroundColor: AppColors.background,
      appBar: AppBar(
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

        child: Obx(() {
          return allDoctorsController.isLoading.value
              ? const Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
              : AllDoctorsWidgets(doctorList: allDoctorsController.doctorList);
        }),
      ),
    );
  }
}
