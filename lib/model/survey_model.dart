import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyModel {
  String? id;
  String? adminId;
  String? title;
  String? description;
  String? surveyType;
  bool? activeStatus;
  Timestamp? createdAt; // ✅ Updated
  SurveyModel({
    this.activeStatus,
    this.adminId,
    this.createdAt,
    this.description,
    this.id,
    this.surveyType,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id ?? "",
      "title": title ?? "",
      "description": description ?? "",
      "surveyType": surveyType ?? "",
      "activeStatus": activeStatus ?? true,
      "adminId": adminId ?? "",
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory SurveyModel.fromMap(Map<String, dynamic> json) {
    final createdAtField = json['createdAt'];

    return SurveyModel(
      id: json['id'] ?? "",
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      surveyType: json['surveyType'],
      adminId: json['adminId'] ?? "",
      activeStatus: json['activeStatus'] ?? true,
      createdAt:
          createdAtField is Timestamp ? createdAtField : null, // ✅ safe casting
    );
  }

  @override
  String toString() {
    return 'SurveyModel('
        'id:$id, '
        'adminId:$adminId, '
        'description:$description, '
        'title:$title, '
        'activeStatus:$activeStatus, '
        'createdAt:$createdAt, '
        'surveyType:$surveyType, '
        ')';
  }
}
