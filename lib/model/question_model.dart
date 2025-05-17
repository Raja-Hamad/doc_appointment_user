import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  String? id;
  String? surveyId;
  String? adminId;
  String? questionText;
  Timestamp? createdAt;
  List<Map<String, dynamic>>? answersList;
  QuestionModel({
    this.adminId,
    this.createdAt,
    this.id,
    this.questionText,
    this.surveyId,
    this.answersList,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id ?? "",
      "adminId": adminId ?? "",
      'questionText': questionText ?? "",
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
      "surveyId": surveyId ?? "",
      "answersList": answersList ?? [],
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> json) {
    final createdAtField = json['createdAt'];
    return QuestionModel(
      id: json['id'] ?? "",
      adminId: json['adminId'] ?? "",
      questionText: json['questionText'] ?? "",
      surveyId: json['surveyId'] ?? "",
      createdAt: createdAtField is Timestamp ? createdAtField : null,
      answersList: List<Map<String, dynamic>>.from(json['answersList'] ?? []),
    );
  }

  @override
  String toString() {
    return 'QuestionModel('
        'id:$id, '
        'adminId:$adminId, '
        'surveyId:$surveyId, '
        'createdAt:$createdAt, '
        'questionText:$questionText, '
        'answersList:$answersList, '
        ')';
  }
}
