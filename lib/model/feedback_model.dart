// feedback_model.dart
class FeedbackResponseModel {
  final String userId;
  final String userName;
  final String userImageUrl;
  final String adminId;
  final String appointmentId;
  final String doctorName;
  final String doctorId;
  final String choosenOption;

  FeedbackResponseModel({
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.adminId,
    required this.appointmentId,
    required this.doctorName,
    required this.doctorId,
    required this.choosenOption,
  });

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'userName': userName,
        'userImageUrl': userImageUrl,
        'adminId': adminId,
        'appointmentId': appointmentId,
        'doctorName': doctorName,
        'doctorId': doctorId,
        'choosenOption': choosenOption,
      };

  factory FeedbackResponseModel.fromMap(Map<String, dynamic> map) {
    return FeedbackResponseModel(
      userId: map['userId'],
      userName: map['userName'],
      userImageUrl: map['userImageUrl'],
      adminId: map['adminId'],
      appointmentId: map['appointmentId'],
      doctorName: map['doctorName'],
      doctorId: map['doctorId'],
      choosenOption: map['choosenOption'],
    );
  }
}

class FeedbackQuestionModel {
  final String questionStatement;
  final List<FeedbackResponseModel> responses;

  FeedbackQuestionModel({
    required this.questionStatement,
    required this.responses,
  });

  Map<String, dynamic> toMap() => {
        'questionStatement': questionStatement,
        'responses': responses.map((r) => r.toMap()).toList(),
      };

  factory FeedbackQuestionModel.fromMap(Map<String, dynamic> map) {
    return FeedbackQuestionModel(
      questionStatement: map['questionStatement'],
      responses: List<FeedbackResponseModel>.from(
        (map['responses'] as List).map((e) => FeedbackResponseModel.fromMap(e)),
      ),
    );
  }
}
