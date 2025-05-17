import 'package:doctor_appointment_user/controller/report_comment_controller.dart';
import 'package:doctor_appointment_user/controller/report_post_controller.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ReportPostNestedBottomSheet extends StatefulWidget {
  String? title;
  String? description;
  List<String>? options;
  String postReportedBy;
 String reportedTo;
  String postId;
  String adminId;
  String postTitle;
  String postDescription;
  String reportedToUserName;
  ReportPostNestedBottomSheet({
    super.key,
    this.description,
    this.options,
    this.title,
    required this.adminId,
    required this.reportedToUserName,
    required this.postDescription,
    required this.postId,
    required this.postReportedBy,
    required this.postTitle,
    required this.reportedTo,
  });

  @override
  State<ReportPostNestedBottomSheet> createState() =>
      _ReportPostNestedBottomSheetState();
}

class _ReportPostNestedBottomSheetState
    extends State<ReportPostNestedBottomSheet> {
  ReportPostController reportPostController = Get.put(ReportPostController());

  ReportCommentController reportController = Get.put(ReportCommentController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SafeArea(
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                if (reportController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(), // Placeholder for alignment
                          Text(
                            "Report",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Divider(color: Colors.black, thickness: 0.3),
                      const SizedBox(height: 5),
                      // Title and Description
                      Text(
                        widget.title ?? '',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.description ?? '',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Report Options
                      ...?widget.options?.map(
                        (option) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: GestureDetector(
                            onTap: () {
                              reportController.reportedTo.value=widget.reportedTo.toString();
                              reportPostController.adminId.value =
                                  widget.adminId.toString();
                              reportPostController.contentType.value = 'post';
                              reportPostController.postDescription.value =
                                  widget.postDescription.toString();
                              reportPostController.postId.value =
                                  widget.postId.toString();
                              reportPostController.postReportedBy.value =
                                  FirebaseAuth.instance.currentUser!.uid;
                              reportPostController.postTitle.value =
                                  widget.postTitle.toString();
                              reportPostController.reportReasonText.value =
                                  option.toString();
                              reportPostController.reportedToUserName.value =
                                  widget.reportedToUserName.toString();
                              reportPostController
                                  .addPostReport(context)
                                  .then((value) {
                                    FlushBarMessages.successMessageFlushBar(
                                      "Post report request submitted successfully",
                                      context,
                                    );
                                  })
                                  .onError((error, stackTrace) {
                                    FlushBarMessages.errorMessageFlushBar(
                                      "Error while submitting post report request is ${error.toString()}",
                                      context,
                                    );
                                  });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      option,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Divider(color: Colors.black, thickness: 0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReportOptionsList extends StatelessWidget {
  List<String>? options;
  ReportOptionsList({super.key, this.options});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: options!.length,
      itemBuilder: (context, index) {
        final option = options![index];
        return Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.black),
                ],
              ),
              const SizedBox(height: 3),
              Container(
                height: .3,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.black),
              ),
            ],
          ),
        );
      },
    );
  }
}
