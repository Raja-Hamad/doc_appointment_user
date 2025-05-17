import 'package:doctor_appointment_user/model/notification_model.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/widgets/notification_details_show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllNotificationWidget extends StatefulWidget {
  List<NotificationModel> notificationList;
  AllNotificationWidget({super.key, required this.notificationList});

  @override
  State<AllNotificationWidget> createState() => _AllNotificationWidgetState();
}

class _AllNotificationWidgetState extends State<AllNotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.notificationList.length,
        itemBuilder: (context, index) {
          final notification = widget.notificationList[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NotificationDetailsShowDialog(
                          description:
                              "${notification.doctorName} has ${notification.appointmentStatus} your Appointment Request",
                          title: "Appointment Request",
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.network(
                            notification.doctorImageUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.notificationTitle.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              notification.notificationBody.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                            ),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Patient Name: ",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  TextSpan(
                                    text: notification.patientName.toString(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Doctor Specialization: ",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        notification.doctorSpecfication
                                            .toString(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              notification.appointmentStatus,
                              style: GoogleFonts.poppins(
                                color:
                                    notification.appointmentStatus == "Approved"
                                        ? AppColors.primary
                                        : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      IconButton(onPressed: () {}, icon: Icon(Icons.delete,
                      color: Colors.red,)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: .5,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.black),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
