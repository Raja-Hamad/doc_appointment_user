import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/controller/comment_controller.dart';
import 'package:doctor_appointment_user/controller/report_post_controller.dart';
import 'package:doctor_appointment_user/model/comment_model.dart';
import 'package:doctor_appointment_user/model/community_post_model.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:doctor_appointment_user/widgets/custom_bottom_sheet.dart';
import 'package:doctor_appointment_user/widgets/report_post_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class AllCommentsView extends StatefulWidget {
  CommunityPostModel communityPostModel;
  AllCommentsView({super.key, required this.communityPostModel});

  @override
  State<AllCommentsView> createState() => _AllCommentsViewState();
}

class _AllCommentsViewState extends State<AllCommentsView> {
  ReportPostController reportPostController = Get.put(ReportPostController());
  LocalStorage localStorage = LocalStorage();
  String? name;
  String? email;
  String? role;
  String? imageUrl;
  bool isLoading = true;

  String? phone;
  Future<void> getValues() async {
    name = await localStorage.getValue("name");
    email = await localStorage.getValue("email");
    role = await localStorage.getValue("role");
    imageUrl = await localStorage.getValue("imageUrl");
    phone = await localStorage.getValue("phone");
    setState(() {
      isLoading = false;
    });
  }

  CommentController commentController = Get.put(CommentController());
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(
        "Image url is the community post is ${widget.communityPostModel.adminImageUrl.toString()}",
      );
      print(
        "title of the commnunity post is ${widget.communityPostModel.postTitle.toString()}",
      );
      print(
        "description of the community post is ${widget.communityPostModel.postDescription.toString()}",
      );
    }
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Comments",
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Obx(() {
          if (reportPostController.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),

                            child: Image.network(
                              widget.communityPostModel.adminImageUrl
                                  .toString(),
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.communityPostModel.postTitle.toString(),
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.communityPostModel.postDescription
                                  .toString(),
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Author Name: ',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        widget.communityPostModel.adminName
                                            .toString(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          isScrollControlled: true,
                          backgroundColor: AppColors.white,
                          builder:
                              (_) => ReportPostBottomSheet(
                                adminId:
                                    widget.communityPostModel.adminId
                                        .toString(),
                                postDescription:
                                    widget.communityPostModel.postDescription
                                        .toString(),
                                postId:
                                    widget.communityPostModel.postId.toString(),
                                postReportedBy:
                                    FirebaseAuth.instance.currentUser!.uid,
                                postTitle:
                                    widget.communityPostModel.postTitle
                                        .toString(),
                                reportedTo:
                                    widget.communityPostModel.adminId
                                        .toString(),
                                reportedToUserName:
                                    widget.communityPostModel.adminName
                                        .toString(),
                              ),
                        );
                      },
                      icon: Icon(Icons.more_horiz, color: Colors.black),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 5),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('admin_actions')
                            .where('actionType', isEqualTo: 'Delete Comment')
                            .snapshots(),
                    builder: (context, adminSnapshot) {
                      if (!adminSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      // Get list of comment IDs that were deleted by admin
                      List<String> deletedCommentIds =
                          adminSnapshot.data!.docs
                              .map((doc) => doc['commentId'].toString())
                              .toList();

                      // Now listen to the comments
                      return StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('comments')
                                .where(
                                  'postId',
                                  isEqualTo: widget.communityPostModel.postId,
                                )
                                .snapshots(),
                        builder: (context, commentSnapshot) {
                          if (!commentSnapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          // Convert and filter comments
                          final allComments =
                              commentSnapshot.data!.docs
                                  .map(
                                    (doc) => CommentModel.fromMap(
                                      doc.data() as Map<String, dynamic>,
                                    ),
                                  )
                                  .where(
                                    (comment) =>
                                        !deletedCommentIds.contains(
                                          comment.commentId,
                                        ),
                                  )
                                  .toList();

                          if (allComments.isEmpty) {
                            return Center(
                              child: Text("No comments available."),
                            );
                          }

                          return ListView.builder(
                            itemCount: allComments.length,
                            itemBuilder: (context, index) {
                              final comment = allComments[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                ),

                                                child: Image.network(
                                                  comment.commenterImageUrl
                                                      .toString(),
                                                  height: 40,
                                                  width: 40,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              comment.commenterName.toString(),
                                              style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                      top: Radius.circular(20),
                                                    ),
                                              ),
                                              isScrollControlled: true,
                                              backgroundColor: AppColors.white,
                                              builder:
                                                  (_) => CustomBottomSheet(
                                                    postDescription:
                                                        widget
                                                            .communityPostModel
                                                            .postDescription
                                                            .toString(),
                                                    reporterImageUrl: imageUrl!,
                                                    reporterName: name!,
                                                    reporterPhoneNumber: phone!,
                                                    commenterImageUrl:
                                                        comment
                                                            .commenterImageUrl
                                                            .toString(),
                                                    commenterPhone:
                                                        comment.commenterPhone
                                                            .toString(),
                                                    commenterName:
                                                        comment.commenterName
                                                            .toString(),
                                                    postTitle:
                                                        widget
                                                            .communityPostModel
                                                            .postTitle
                                                            .toString(),
                                                    commentText:
                                                        comment.commentText
                                                            .toString(),
                                                    adminId:
                                                        comment.adminId
                                                            .toString(),
                                                    commentId:
                                                        comment.commentId
                                                            .toString(),
                                                    reportedTo:
                                                        comment.commenterId
                                                            .toString(),
                                                    reportedToUserName:
                                                        comment.commenterName
                                                            .toString(),
                                                    // title: "Forget Password",
                                                    // buttonText: "Reset Password",
                                                    // onSubmit: () {
                                                    //   // Call your reset method here
                                                    // },
                                                  ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.more_horiz,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      comment.commentText.toString(),
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        }),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController.commentController.value,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: AppColors.primary),
                onPressed: () {
                  commentController.commentText.value =
                      commentController.commentController.value.text
                          .trim()
                          .toString();
                  commentController.adminId.value =
                      widget.communityPostModel.adminId.toString();
                  commentController
                      .addComment(
                        context,
                        widget.communityPostModel.postId.toString(),
                        imageUrl!,
                        name!,
                        phone!,
                      )
                      .then((value) {
                        commentController.commentController.value.clear();
                      })
                      .onError((error, stackTrace) {
                        FlushBarMessages.errorMessageFlushBar(
                          "Error while uploading the comment ${error.toString()}",
                          context,
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
