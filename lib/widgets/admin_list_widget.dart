import 'package:doctor_appointment_user/model/user_model.dart';
import 'package:doctor_appointment_user/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class AdminListWidget extends StatefulWidget {
  List<UserModel> list;
  AdminListWidget({super.key, required this.list});

  @override
  State<AdminListWidget> createState() => _AdminListWidgetState();
}

class _AdminListWidgetState extends State<AdminListWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          final admin = widget.list[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatView(
                  adminDeviceToken: admin.userDeviceToken.toString(),
                  adminId: admin.id,
                  adminName: admin.name,
                )));
              },
              child: ListTile(
                leading:ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: Image.asset("assets/images/dummy_doctor.jpg",
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,),
                  ),
                ),
                title: Text(
                  admin.name,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  admin.email,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
