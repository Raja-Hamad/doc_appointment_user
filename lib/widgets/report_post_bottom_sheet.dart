import 'package:doctor_appointment_user/controller/comment_controller.dart';

import 'package:doctor_appointment_user/widgets/report_post_nested_bottom_sheet.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ReportPostBottomSheet extends StatefulWidget {
  String postReportedBy;
  String reportedTo;
  String postId;
  String adminId;
  String postTitle;
  String postDescription;
  String reportedToUserName;
  ReportPostBottomSheet({
    super.key,
    required this.adminId,
    required this.postDescription,
    required this.postId,
    required this.postReportedBy,
    required this.postTitle,
    required this.reportedTo,
    required this.reportedToUserName,
  });

  @override
  State<ReportPostBottomSheet> createState() => _ReportPostBottomSheetState();
}

class _ReportPostBottomSheetState extends State<ReportPostBottomSheet> {
  CommentController commentController = Get.put(CommentController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> reportOptionsList = [
      'Harassment or Bullying',

      'Hate Speech or Symbols',

      'Violence or Threats',

      'Sexual Content',

      'Spam or Misleading',

      'Self-Harm or Suicide',

      'False Information',

      'Other',
    ];
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          if (commentController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder:
                          (_) => ReportPostNestedBottomSheet(
                            reportedToUserName: widget.reportedToUserName,
                          
                            reportedTo: widget.reportedTo.toString(),
                            postReportedBy: widget.postReportedBy,
                            postDescription: widget.postDescription.toString(),
                            postId: widget.postId.toString(),
                            postTitle: widget.postTitle.toString(),
                            adminId: widget.adminId.toString(),
                            options: reportOptionsList,
                            title: "Why are you reporting this post?",
                            description:
                                "If someone is in immediate danger, get help before reporting to this. Don't wait",
                          ),
                    );
                  },
                  child: ReusableBottomSheetWidget(
                    prefixIcon: Icon(Icons.report_problem, color: Colors.black),
                    title: "Report Post",
                    description:
                        "We won't let ${widget.reportedToUserName} know who reported this",
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReusableBottomSheetWidget extends StatelessWidget {
  Icon? prefixIcon;
  String? title;
  String? description;
  ReusableBottomSheetWidget({
    super.key,
    this.description,
    this.prefixIcon,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        prefixIcon!,
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title!,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                description!,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
