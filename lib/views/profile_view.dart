
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:doctor_appointment_user/views/update_profile_view.dart';
import 'package:doctor_appointment_user/widgets/reusable_containr_widget.dart';
import 'package:doctor_appointment_user/widgets/submit_button_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  LocalStorage localStorage = LocalStorage();
  String? email;
  String? name;
  @override
  void initState() {
    super.initState();
    getValues();
  }

  void getValues() async {
    email = await localStorage.getValue("email");
    name = await localStorage.getValue("name");

    if (kDebugMode) {
      print("Name of the user is ${name ?? ""}");
      print("email of the users is ${email ?? ""}");
    }
    setState(() {});
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
                "Profile 👋",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ReusableContainerWidget(title: "Name", containerText: name ?? ""),
              const SizedBox(height: 16),
              ReusableContainerWidget(
                containerText: email ?? "",
                title: "Email",
              ),
              const SizedBox(height: 40),
              SubmitButtonWidget(
                buttonColor: AppColors.primary,
                title: "Update Profile",
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => UpdateProfileView(
                            email: email ?? "",
                            name: name ?? "",
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
