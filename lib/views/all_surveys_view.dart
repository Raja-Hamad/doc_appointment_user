import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/model/survey_model.dart';
import 'package:doctor_appointment_user/views/all_questions_view.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllSurveysView extends StatefulWidget {
  const AllSurveysView({super.key});

  @override
  State<AllSurveysView> createState() => _AllSurveysViewState();
}

class _AllSurveysViewState extends State<AllSurveysView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Surveys",
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
                          .collection("surveys")
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final survey =
                        snapshot.data!.docs
                            .map((json) => SurveyModel.fromMap(json.data()))
                            .toList();
                    return ListView.builder(
                      itemCount: survey.length,
                      itemBuilder: (context, index) {
                        final surveyData = survey[index];
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => AllQuestionsView(
                                      surveyId: surveyData.id ?? "",
                                    ),
                              ),
                            );
                          },
                          title: Text(
                            surveyData.title.toString(),
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
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  surveyData.description.toString(),
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  "Survey Type: ${surveyData.surveyType.toString()}",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
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
