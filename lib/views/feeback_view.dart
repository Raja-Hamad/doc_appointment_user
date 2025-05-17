import 'package:doctor_appointment_user/controller/feedback_controller.dart';
import 'package:doctor_appointment_user/model/appointment_booking_model.dart';
import 'package:doctor_appointment_user/model/feedback_model.dart';

import 'package:doctor_appointment_user/utils/app_colors.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:doctor_appointment_user/utils/local_storage.dart';
import 'package:doctor_appointment_user/widgets/submit_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FeebackView extends StatefulWidget {
  final AppointmentBookingModel appointmentBookingModel;

  const FeebackView({super.key, required this.appointmentBookingModel});

  @override
  State<FeebackView> createState() => _FeebackViewState();
}

class _FeebackViewState extends State<FeebackView> {
  final FeedbackController _feedbackController = Get.put(FeedbackController());
  final LocalStorage _localStorage = LocalStorage();

  String? _schedulingEase;
  String? _facilityCleanliness;
  String? generalExperience;
  String? doctorInteraction;
  String? doctorAttention;

  String? name, phone, imageUrl, userId;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    name = await _localStorage.getValue("name");
    phone = await _localStorage.getValue("phone");
    imageUrl = await _localStorage.getValue("imageUrl");
    userId = FirebaseAuth.instance.currentUser?.uid;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Give Feedback",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                FeedbackQuestionWidget(
                  questionText:
                      'How would you rate the ease of scheduling your appointment?',
                  options: [
                    'Very Easy',
                    'Easy',
                    'Neutral',
                    'Difficult',
                    'Very Difficult',
                  ],
                  selectedOption: _schedulingEase,
                  onChanged: (value) => setState(() => _schedulingEase = value),
                ),
                const SizedBox(height: 16),
                FeedbackQuestionWidget(
                  questionText:
                      'How satisfied are you with the cleanliness and comfort of the facility?',
                  options: [
                    'Very Satisfied',
                    'Satisfied',
                    'Neutral',
                    'Dissatisfied',
                    'Very Dissatisfied',
                  ],
                  selectedOption: _facilityCleanliness,
                  onChanged:
                      (value) => setState(() => _facilityCleanliness = value),
                ),
                const SizedBox(height: 16),
                FeedbackQuestionWidget(
                  questionText:
                      'How satisfied are you with the overall experience of the appointment?',
                  options: [
                    'Very Satisfied',
                    'Satisfied',
                    'Neutral',
                    'Dissatisfied',
                    'Very Dissatisfied',
                  ],
                  selectedOption: generalExperience,
                  onChanged:
                      (value) => setState(() => generalExperience = value),
                ),
                const SizedBox(height: 16),
                FeedbackQuestionWidget(
                  questionText:
                      'How would you rate the doctors explanation of your health concerns?',
                  options: [
                    'Excellent',
                    'Good',
                    'Average',
                    'Poor',
                    'Very Poor',
                  ],
                  selectedOption: doctorInteraction,
                  onChanged:
                      (value) => setState(() => doctorInteraction = value),
                ),
                const SizedBox(height: 16),
                FeedbackQuestionWidget(
                  questionText:
                      'Did the doctor listen to you carefully and respond appropriately?',
                  options: [
                    'Strongly Agree',
                    'Agree',
                    'Neutral',
                    'Disagree',
                    'Strongly Disagree',
                  ],
                  selectedOption: doctorAttention,
                  onChanged: (value) => setState(() => doctorAttention = value),
                ),
                const SizedBox(height: 24),
                SubmitButtonWidget(
                  buttonColor: AppColors.primary,

                  title: "Submit",
                  isLoading: _feedbackController.isLoading.value,
                  onPress: () async {
                    if (_schedulingEase != null &&
                        _facilityCleanliness != null) {
                      final user = FirebaseAuth.instance.currentUser!;
                      final response1 = FeedbackResponseModel(
                        userId: user.uid,
                        userName: name ?? '',
                        userImageUrl: imageUrl ?? '',
                        adminId: widget.appointmentBookingModel.adminId!,
                        appointmentId: widget.appointmentBookingModel.id!,
                        doctorName: widget.appointmentBookingModel.doctorName!,
                        doctorId: widget.appointmentBookingModel.doctorId!,
                        choosenOption: _schedulingEase!,
                      );

                      final response2 = FeedbackResponseModel(
                        userId: user.uid,
                        userName: name ?? '',
                        userImageUrl: imageUrl ?? '',
                        adminId: widget.appointmentBookingModel.adminId!,
                        appointmentId: widget.appointmentBookingModel.id!,
                        doctorName: widget.appointmentBookingModel.doctorName!,
                        doctorId: widget.appointmentBookingModel.doctorId!,
                        choosenOption: _facilityCleanliness!,
                      );
                      final reponse3 = FeedbackResponseModel(
                        userId: user.uid,
                        userName: name ?? '',
                        userImageUrl: imageUrl ?? '',
                        adminId: widget.appointmentBookingModel.adminId!,
                        appointmentId: widget.appointmentBookingModel.id!,
                        doctorName: widget.appointmentBookingModel.doctorName!,
                        doctorId: widget.appointmentBookingModel.doctorId!,
                        choosenOption: generalExperience!,
                      );
                      final reponse4 = FeedbackResponseModel(
                        userId: user.uid,
                        userName: name ?? '',
                        userImageUrl: imageUrl ?? '',
                        adminId: widget.appointmentBookingModel.adminId!,
                        appointmentId: widget.appointmentBookingModel.id!,
                        doctorName: widget.appointmentBookingModel.doctorName!,
                        doctorId: widget.appointmentBookingModel.doctorId!,
                        choosenOption: doctorInteraction!,
                      );
                      final reponse5 = FeedbackResponseModel(
                        userId: user.uid,
                        userName: name ?? '',
                        userImageUrl: imageUrl ?? '',
                        adminId: widget.appointmentBookingModel.adminId!,
                        appointmentId: widget.appointmentBookingModel.id!,
                        doctorName: widget.appointmentBookingModel.doctorName!,
                        doctorId: widget.appointmentBookingModel.doctorId!,
                        choosenOption: doctorAttention!,
                      );

                      await _feedbackController
                          .submitFeedbackResponse(
                            question:
                                'How would you rate the ease of scheduling your appointment?',
                            response: response1,
                          )
                          .then((value) {
                            _schedulingEase = null;
                          });

                      await _feedbackController
                          .submitFeedbackResponse(
                            question:
                                'How satisfied are you with the cleanliness and comfort of the facility?',
                            response: response2,
                          )
                          .then((value) {
                            _facilityCleanliness = null;
                          });
                      await _feedbackController
                          .submitFeedbackResponse(
                            question:
                                'How satisfied are you with the overall experience of the appointment?',
                            response: reponse3,
                          )
                          .then((value) {
                            generalExperience = null;
                          });
                      await _feedbackController
                          .submitFeedbackResponse(
                            question:
                                'How would you rate the doctors explanation of your health concerns?',
                            response: reponse4,
                          )
                          .then((value) {
                            doctorInteraction = null;
                          });

                      await _feedbackController
                          .submitFeedbackResponse(
                            question:
                                'Did the doctor listen to you carefully and respond appropriately?',
                            response: reponse5,
                          )
                          .then((value) {
                            doctorAttention = null;
                          });

                      FlushBarMessages.successMessageFlushBar(
                        "Feedback submitted successfully",

                        context,
                      );
                    } else {
                      FlushBarMessages.errorMessageFlushBar(
                        "Please answer all questions",
                        context,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeedbackQuestionWidget extends StatelessWidget {
  final String questionText;
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String?> onChanged;

  const FeedbackQuestionWidget({
    super.key,
    required this.questionText,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          questionText,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        ...options.map((option) {
          return RadioListTile<String>(
            title: Text(
              option,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            value: option,
            groupValue: selectedOption,
            onChanged: onChanged,
          );
        }),
      ],
    );
  }
}
