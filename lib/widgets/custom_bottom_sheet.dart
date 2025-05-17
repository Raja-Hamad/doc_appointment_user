import 'package:doctor_appointment_user/controller/comment_controller.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:doctor_appointment_user/widgets/nested_report_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomSheet extends StatefulWidget {
  // final String title;
  // final String buttonText;
  // final VoidCallback onSubmit;
  final String reportedToUserName;
  final String commentId;
  final String reportedTo;
  final String adminId;
  final String postTitle;
  final String commentText;
  final String commenterName;
  final String commenterPhone;
  String commenterImageUrl;
  final String reporterName;
  final String reporterImageUrl;
  final String reporterPhoneNumber;
  final String postDescription;
  CustomBottomSheet({
    super.key,
    // required this.title,
    // required this.buttonText,
    // required this.onSubmit,
    required this.reportedToUserName,
    required this.commentText,
    required this.postTitle,
    required this.adminId,
    required this.commenterName,
    required this.postDescription,
    required this.reportedTo,
    required this.commentId,
    required this.commenterPhone,
    required this.commenterImageUrl,
    required this.reporterImageUrl,
    required this.reporterName,
    required this.reporterPhoneNumber,
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  CommentController commentController = Get.put(CommentController());
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("Comment text is ${widget.commentText.toString()}");
      print("post title is ${widget.postTitle.toString()}");
    }
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
                GestureDetector(
                  onTap: () {
                    commentController.commentId.value =
                        widget.commentId.toString();
                    commentController
                        .deleteComment(context)
                        .then((value) {
                          FlushBarMessages.successMessageFlushBar(
                            "Comment deleted successfully",
                            context,
                          );
                        })
                        .onError((error, stackTrace) {
                          FlushBarMessages.errorMessageFlushBar(
                            "Error deleting the comment ${error.toString()}",
                            context,
                          );
                        });
                  },
                  child: ReusableBottomSheetWidget(
                    prefixIcon: Icon(Icons.delete, color: Colors.black),
                    title: "Delete Comment",
                    description:
                        "Deleting your comment will be deleted from this post feed as well",
                  ),
                ),

                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder:
                          (_) => NestedReportBottomSheet(
                            postDescription: widget.postDescription.toString(),
                            reporterImageUrl:
                                widget.reporterImageUrl.toString(),
                            reporterName: widget.reporterName.toString(),
                            reporterPhoneNumber:
                                widget.reporterPhoneNumber.toString(),
                            commenterImageUrl:
                                widget.commenterImageUrl.toString(),
                            commenterPhone: widget.commenterPhone.toString(),
                            commenterName: widget.commenterName.toString(),
                            postTitle: widget.postTitle.toString(),
                            commentText: widget.commentText.toString(),
                            adminId: widget.adminId.toString(),
                            commentId: widget.commentId.toString(),
                            reportedTo: widget.reportedTo,
                            options: reportOptionsList,
                            title: "Why are you reporting this comment?",
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
