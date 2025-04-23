
import 'package:doctor_appointment_user/config/routes/route_names.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/widgets/submit_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome To",
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Doc Appointment",
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 200,),
            SubmitButtonWidget(
              onPress: (){
                Navigator.pushNamed(context, RouteNames.signUpRoute);
              },
              buttonColor: AppColors.primary, title: "Get Started")
          ],
        ),
      ),
    );
  }
}
