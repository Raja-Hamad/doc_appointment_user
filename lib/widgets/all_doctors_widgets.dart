import 'package:doctor_appointment_user/controller/all_doctors_controller.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/views/doctor_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AllDoctorsWidgets extends StatefulWidget {
  final List doctorList;
  final void Function(int index)? onEditTap;
  final void Function(int index)? onDeleteTap;

  const AllDoctorsWidgets({
    super.key,
    required this.doctorList,
    this.onEditTap,
    this.onDeleteTap,
  });

  @override
  State<AllDoctorsWidgets> createState() => _AllDoctorsWidgetsState();
}

class _AllDoctorsWidgetsState extends State<AllDoctorsWidgets> {
  AllDoctorsController allDoctorsController = Get.put(AllDoctorsController());
  @override
  Widget build(BuildContext context) {
    if (widget.doctorList.isEmpty) {
      return Center(
        child: Text(
          "No Doctors Found",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: widget.doctorList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final doctor = widget.doctorList[index];

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
                          (context) => DoctorDetailsView(doctorModel: doctor),
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
}
