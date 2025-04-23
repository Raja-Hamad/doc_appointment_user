import 'dart:convert';

import 'package:doctor_appointment_user/controller/appointment_booking_controller.dart';
import 'package:doctor_appointment_user/model/appointment_booking_model.dart';
import 'package:doctor_appointment_user/model/doctor_model.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:doctor_appointment_user/widgets/submit_button_widget.dart';
import 'package:doctor_appointment_user/widgets/text_field_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class BookAppointmentView extends StatefulWidget {
  DoctorModel doctorModel;
  BookAppointmentView({super.key, required this.doctorModel});

  @override
  State<BookAppointmentView> createState() => _BookAppointmentViewState();
}

class _BookAppointmentViewState extends State<BookAppointmentView> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedBookingType;
  List<String> bookingTypes = ['In-Person', "Online"];
  AppointmentBookingController appointmentBookingController = Get.put(
    AppointmentBookingController(),
  );

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF38B18A), // header & active color
              onPrimary: Colors.white, // text color on primary
              onSurface: Colors.black, // default text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF38B18A), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              dialHandColor: Color(0xFF38B18A),
              dialBackgroundColor: Colors.grey.shade100,
              entryModeIconColor: Color(0xFF38B18A),
              hourMinuteTextColor: Colors.black,
              hourMinuteColor: Colors.grey.shade100,
              helpTextStyle: TextStyle(
                color: Color(0xFF38B18A),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            colorScheme: ColorScheme.light(
              primary: Color(0xFF38B18A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  TextEditingController patientNameController = TextEditingController();
  TextEditingController patientNumberControler = TextEditingController();
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Book Appointment 👋",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  controller: patientNameController,
                  isPassword: false,
                  label: "Enter patient Name",
                ),
                const SizedBox(height: 16),
                TextFieldWidget(
                  controller: patientNumberControler,
                  isPassword: false,
                  label: "Enter Number",
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Pick Date
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            selectedDate != null
                                ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                                : "Pick Date",
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Pick Time
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            selectedTime != null
                                ? selectedTime!.format(context)
                                : "Pick Time",
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedBookingType,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF38B18A),
                      ),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      hint: Text(
                        'Select Booking Type',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      items:
                          bookingTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBookingType = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFieldWidget(
                  controller: notesController,
                  isPassword: false,
                  label: "Enter Additional Note",
                ),
                const SizedBox(height: 60),
                Obx(() {
                  return SubmitButtonWidget(
                    buttonColor: AppColors.primary,
                    title: "Confirm Appointment",
                    isLoading: appointmentBookingController.isLoading.value,
                    onPress: () async {
                      String createdAt = DateTime.now().toIso8601String(); // 🔥

                      String formattedDate =
                          selectedDate != null
                              ? "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}"
                              : '';

                      String formattedTime =
                          selectedTime != null
                              ? selectedTime!.format(context)
                              : '';

                      LocalStorage localStorage = LocalStorage();

                      String? userId = await localStorage.getValue("id");
                      String userName =
                          patientNameController.text.trim().toString();
                      String userPhone =
                          patientNumberControler.text.trim().toString();
                      String additionalNotes =
                          notesController.text.trim().toString();
                      String doctorName = widget.doctorModel.name.toString();
                      String doctorId = widget.doctorModel.id.toString();
                      String doctorImageUrl =
                          widget.doctorModel.imageUrl.toString();
                      String aboutDoctor =
                          widget.doctorModel.aboutDoctor.toString();
                      String doctorSpecialization =
                          widget.doctorModel.specialization.toString();
                      String bookingType = selectedBookingType ?? "";
                      String adminId = widget.doctorModel.adminId;
                      String adminDeviceToken =
                          widget.doctorModel.adminDeviceToken;
                      String? userDeviceToken = await localStorage.getValue(
                        "userDeviceToken",
                      );
                      AppointmentBookingModel appointmentBookingModel =
                          AppointmentBookingModel(
                            userDeviceToken: userDeviceToken ?? "",
                            adminId: adminId,
                            id: Uuid().v4(),
                            aboutDoctor: aboutDoctor,
                            doctoImageUrl: doctorImageUrl,
                            specialization: doctorSpecialization,
                            appointmentDate: formattedDate,
                            appointmentTime: formattedTime,
                            bookingStatus: "Pending",
                            bookingType: bookingType,
                            createdAt: createdAt,
                            doctorId: doctorId,
                            doctorName: doctorName,
                            notes: additionalNotes,
                            number: userPhone,
                            patientName: userName,
                            userId: userId ?? "",
                          );

                      appointmentBookingController
                          .appointmentBooking(appointmentBookingModel, context)
                          .then((value) async {
                            await submitNotification(
                              adminDeviceToken,
                              "Appointment Request",
                              "$userName has Requested for the Appointment against $doctorName",
                              doctorImageUrl,
                            );
                          });
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "doctor-appointment-app-f73f5",
      "private_key_id": "ff7c5feef5e6ce52c9af45e54e99b6ec76413b7a",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCydfO35Tsf+6i7\nVhJx6kDNxI3O6fq+eoLb/VuVfdCwvJYjjQvu4GfUkEzuS3vUeB0BlLbXJi+tE2Zt\nj9RU+rdNfo8w2YdB9PnIqgTNMuKoDfDR5uaL1CBDGii2GRaLITPDeKiCCIx3y/7X\nLMubAiz76bEfcPY/tq+LKayzVNimrktgq3jhE/C+eKJrWG4R9drLzS+ClIIaRfGa\nhNoA6v8l56HQ7AoIoC77HIcKSuiyOLsaz+VvK2NkVAqT5RtRZioawNtLrW1YYgNO\nLGWLAJDLjGvplqHe/gMgNsCw1CdVEXO+rKy4XBc1TaNe4KohmalYV8Fe9WqeiYtY\nIy9NKkv/AgMBAAECggEAIJNtYKUkbMsoWsH0bfzfxW/anumRDtIYLwYJgLlNreVO\n1sB5bCpkaaXJlToMKZWfXdmCorViwIopCVjW3ohBi5DNnJIooX6RVfLLG5XtT9Xz\nnq0yalXXachNpCfiOJVf+I9+2vWqhnejVi3kILB9+6IF5gJdwPWdB58c2kNjpNEf\nx1IffxEEWgcas28kfQTKVraMafluoTzv6Vxk7yV9627mGanvBvMyZpOPf9W3QQvY\n32RT468IzxIsKL5F6IxfFcLqKPVqnRWR8h3OOUhvQiNDqW4Lde54s+/F2ifXI8zJ\ntRL48xkQp/OfmKgnY7EdpxVxL+Ojlmk2U+TMtVwu+QKBgQDm305yqQyayg+xlFNW\nevVB8HW1o93B/G8uQYW4sp9w1vJ8y0lfLgE82hCAgLP/p08jTU++L/uPBnAumkPV\nsGr7pYDw/KjoIWwRI6q+wcO0fPuvtZ31CcpsbjKq338BgitREJXA84k+BiYdoXND\nebUTvVkP6f9TMGKsUdKAu23vdQKBgQDF4lNmBQBvrP2bjVhsOH87CAwa3gLP5Rji\nPeuAKE1fmGdn0ZH2Db0yauAczkFanSc5iJyms232bqVpQVRvO6DG99QLAnBGaxtf\nao9W/HQfmHIuZXPwAXpoJKRT64gtxUphYgsQs9qJNvAQqIaLUO/KTsS88PPgj7XS\n/vj0By1zIwKBgDg4UqsbPWWIJPAyVWTuxkCLZK6Zu8ucRBq4e+6xGKBqx1vaSQCz\nfDusQm54aNytiljnX67JknGOuMywZipoLnUfJVoJvLviP6Wg0Nho6NZPxR5RlKhx\n/OgQoaf4ir38S74O0tjMtTP0XV3DzgS1Y4HuDv0QF0vTsYOS3TbZ7XhtAoGAPsn4\nwodVwxm2AvSPmQ84N8fu51uIsuSzx530Kt8e5fVa4lNaKCPl46iL4jgD/rec6aGS\na0bF3orvS32iSAU4l8mta6zjaUS1E8qhHu3N/vSFTnl8lyww5fiyd7plpHhUiJ/u\neOdIsX9QH0kKIAyXea8SuA0QpTGUdRXYcr4QStcCgYBI2/5CpWlnvnF2fFogVb/k\nnaouw0Z6ZM1U5THvowM/HXTRfS0Wq5W64TdBkjz7uiuc8lxmouyi8FkUy8LdI4Fw\nVl2Z/h3G1i2uHDyXh8LgjLJeRcLaUP9NzJUecotHe3CI7X8nKAV199gPI9ky9P5G\nDMvs0DC1Zqrhk09zX+Gy8g==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-fbsvc@doctor-appointment-app-f73f5.iam.gserviceaccount.com",
      "client_id": "109067369366173919564",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40doctor-appointment-app-f73f5.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials = await auth
        .obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client,
        );

    client.close();
    return credentials.accessToken.data;
  }

  Future<void> sendNotificationToClients(
    String notificationBody,
    String notificationTitle,
    String devicesToken,
    String doctoImageUrl,
  ) async {
    final String serverKey = await getAccessToken();

    var notificationData = {
      'message': {
        'token': devicesToken,
        'notification': {
          'title': notificationTitle.toString(),
          'body': notificationBody.toString(),
          'image': doctoImageUrl, // Add image URL if you have one
        },
        'data': {'image': doctoImageUrl},
      },
    };

    var response = await http.post(
      Uri.parse(
        'https://fcm.googleapis.com/v1/projects/doctor-appointment-app-f73f5/messages:send',
      ), // Update YOUR_PROJECT_ID
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $serverKey', // Replace with actual access token
      },
      body: jsonEncode(notificationData),
    );

    // Check response for errors
    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print(
        'Error sending notification: ${response.statusCode} - ${response.reasonPhrase}',
      );
      print('Response body: ${response.body}');
    }
  }

  submitNotification(
    String userDeviceToken,
    String notificationTitle,
    String notificationBody,
    String doctorImageUr,
  ) async {
    try {
      if (kDebugMode) {
        print("Device Token of the user is $userDeviceToken");
        print("Notification Title of the user is $notificationTitle");
        print("Notification Body of the user is $notificationBody");
      }
      if (notificationTitle.isNotEmpty && notificationBody.isNotEmpty) {
        await sendNotificationToClients(
          notificationBody,
          notificationTitle,
          userDeviceToken,
          doctorImageUr,
        );
      } else {
        print("Please fill in all fields.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while generating the notification ${e.toString()}");
      }
    }
  }
}
