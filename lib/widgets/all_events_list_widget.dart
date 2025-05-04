import 'package:doctor_appointment_user/controller/events_controller.dart';
import 'package:doctor_appointment_user/model/events_model.dart';
import 'package:doctor_appointment_user/views/event_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class AllEventsListWidget extends StatefulWidget {
  List<EventsModel> list;
  AllEventsListWidget({super.key, required this.list});

  @override
  State<AllEventsListWidget> createState() => _AllEventsListWidgetState();
}

class _AllEventsListWidgetState extends State<AllEventsListWidget> {
  EventsController controller = Get.put(EventsController());
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: (ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          final event = widget.list[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsView(model: event),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      event.eventTitle.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.eventDescription.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(event.eventDate.toString()),
                        ],
                      ),
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),

                        child: Image.network(
                          event.imageUrl.toString(),
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    trailing: Text(
                      event.eventTime.toString(),
                      style: GoogleFonts.poppins(),
                    ),
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
      )),
    );
  }
}
