
import 'package:doctor_appointment_user/controller/update_profile_controller.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:doctor_appointment_user/widgets/submit_button_widget.dart';
import 'package:doctor_appointment_user/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class UpdateProfileView extends StatefulWidget {
  String name;
  String email;
  UpdateProfileView({super.key, required this.email, required this.name});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  UpdateProfileController updateProfileController = Get.put(
    UpdateProfileController(),
  );
  @override
  void initState() {
    super.initState();
    updateProfileController.textEditingControllerEmail.value.text =
        widget.email;
    updateProfileController.textEditingControllerName.value.text = widget.name;
  }
  LocalStorage localStorage=LocalStorage();

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
                "Update Profile 👋",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFieldWidget(
                controller:
                    updateProfileController.textEditingControllerName.value,
                isPassword: false,
                label: "Name",
              ),
              const SizedBox(height: 16),
              TextFieldWidget(
                controller:
                    updateProfileController.textEditingControllerEmail.value,
                isPassword: false,
                label: "Email",
              ),
              const SizedBox(height: 40),
              Obx(() {
                return SubmitButtonWidget(
                  buttonColor: AppColors.primary,
                  title: "Update",
                  isLoading: updateProfileController.isLoading.value,
                  onPress: () {
                    updateProfileController.updateProfile(
                      updateProfileController
                              .textEditingControllerEmail
                              .value
                              .text
                              .isEmpty
                          ? widget.email
                          : updateProfileController
                              .textEditingControllerEmail
                              .value
                              .text,
                      updateProfileController
                              .textEditingControllerName
                              .value
                              .text
                              .isEmpty
                          ? widget.name
                          : updateProfileController
                              .textEditingControllerName
                              .value
                              .text,
                      context,
                    ).then((value)async{
await localStorage.clear("name");
await localStorage.clear("email");
                    });
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
