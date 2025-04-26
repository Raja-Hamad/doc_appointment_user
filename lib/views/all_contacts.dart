import 'package:doctor_appointment_user/controller/fetch_all_admins_controller.dart';
import 'package:doctor_appointment_user/widgets/admin_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';

class AllContacts extends StatefulWidget {
  const AllContacts({super.key});

  @override
  State<AllContacts> createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {
  FetchAllAdminsController fetchAllAdminsController = Get.put(
    FetchAllAdminsController(),
  );
  @override
  void initState() {
    super.initState();
    fetchAllAdminsController.allAdminsList(context);
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
                "Chat with Doctors 👋",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Obx(() {
                if (fetchAllAdminsController.allAdmins.isEmpty) {
                  return Center(
                    child: Text(
                      "No Doctor found",
                      style: GoogleFonts.poppins(),
                    ),
                  );
                } else if (fetchAllAdminsController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (fetchAllAdminsController.allAdmins.isNotEmpty) {
                  return AdminListWidget(
                    list: fetchAllAdminsController.allAdmins,
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
