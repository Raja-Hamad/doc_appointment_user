
import 'package:doctor_appointment_user/config/routes/route_names.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:doctor_appointment_user/views/bottom_nav_bar.dart';
import 'package:doctor_appointment_user/widgets/submit_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  LocalStorage localStorage=LocalStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset("assets/images/splash_icon.png",
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,),
            ),
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

            const SizedBox(height: 100,),
            SubmitButtonWidget(
              onPress: ()async{
                
                String? id = await localStorage.getValue("id");
                if (id != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavBar()),
                  );
                } else {
                  Navigator.pushNamed(context, RouteNames.signInRoute);
                }
            
              },
              buttonColor: AppColors.primary, title: "Get Started")
          ],
        ),
      ),
    );
  }
}
