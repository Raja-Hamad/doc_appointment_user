import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class NotificationDetailsShowDialog extends StatefulWidget {
  String title;
  String description;

  NotificationDetailsShowDialog({
    super.key,
    required this.description,
    required this.title,
  });

  @override
  State<NotificationDetailsShowDialog> createState() =>
      _NotificationDetailsShowDialogState();
}

class _NotificationDetailsShowDialogState
    extends State<NotificationDetailsShowDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.title,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        widget.description,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w300,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "OK",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
