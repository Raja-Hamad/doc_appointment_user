import 'package:doctor_appointment_user/authentication/login_screen.dart';
import 'package:doctor_appointment_user/authentication/signup_screen.dart';
import 'package:doctor_appointment_user/config/routes/route_names.dart';
import 'package:doctor_appointment_user/splash_screen.dart';
import 'package:doctor_appointment_user/views/all_doctors_view.dart';
import 'package:doctor_appointment_user/views/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashRroute:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case RouteNames.signInRoute:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RouteNames.signUpRoute:
        return MaterialPageRoute(builder: (context) => SignupScreen());

      case RouteNames.allDoctorsScreenRoute:
        return MaterialPageRoute(builder: (context) => AllDoctorsView());
        case RouteNames.navBarScreenRoute:
        return MaterialPageRoute(builder: (context) => BottomNavBar());

      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(body: Center(child: Text("No route found")));
          },
        );
    }
  }
}
