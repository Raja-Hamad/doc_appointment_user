import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/controller/survey_controller.dart';

import 'package:doctor_appointment_user/model/question_model.dart';
import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:doctor_appointment_user/widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class AllQuestionsView extends StatefulWidget {
  String surveyId;
  AllQuestionsView({super.key, required this.surveyId});

  @override
  State<AllQuestionsView> createState() => _AllQuestionsViewState();
}

class _AllQuestionsViewState extends State<AllQuestionsView> {
  SurveyController surveyController = Get.put(SurveyController());
  LocalStorage localStorage = LocalStorage();
  String? name;
  String? email;
  String? role;
  String? imageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getValues();
  }

  Future<void> getValues() async {
    name = await localStorage.getValue("name");
    email = await localStorage.getValue("email");
    role = await localStorage.getValue("role");
    imageUrl = await localStorage.getValue("imageUrl");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.black))
              : SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "All Questions",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: StreamBuilder(
                          stream:
                              FirebaseFirestore.instance
                                  .collection("survey_questions")
                                  .where("surveyId", isEqualTo: widget.surveyId)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              );
                            }
                            final questionsList =
                                snapshot.data!.docs
                                    .map(
                                      (json) =>
                                          QuestionModel.fromMap(json.data()),
                                    )
                                    .toList();

                            return ListView.builder(
                              itemCount: questionsList.length,
                              itemBuilder: (context, index) {
                                final question = questionsList[index];
                                return ListTile(
                                  title: Theme(
                                    data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent,
                                    ),
                                    child: ListTileTheme(
                                      contentPadding: EdgeInsets.zero,
                                      child: ExpansionTile(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                          side: BorderSide(
                                            width: 0,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        collapsedShape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                          side: BorderSide(
                                            width: 0,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        title: Text(
                                          question.questionText ?? "",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        children: [
                                          TextFieldWidget(
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                Map<String, dynamic> data = {
                                                  "userId":
                                                      FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                  "userImage": imageUrl,
                                                  "userName": name,
                                                  'answerText':
                                                      surveyController
                                                          .answerController
                                                          .value
                                                          .text
                                                          .trim()
                                                          .toString(),
                                                };
                                                surveyController
                                                    .uploadReponse(
                                                      data,
                                                      question.id ?? "",
                                                      widget.surveyId
                                                          .toString(),
                                                      context,
                                                    )
                                                    .then((value) {
                                                      surveyController
                                                          .answerController
                                                          .value
                                                          .clear();
                                                    });
                                              },
                                              icon: Icon(
                                                Icons.send,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            controller:
                                                surveyController
                                                    .answerController
                                                    .value,
                                            isPassword: false,
                                            label: "Enter answer",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
