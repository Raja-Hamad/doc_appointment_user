import 'package:cloud_firestore/cloud_firestore.dart';

class ReportPostModel {
  String? reportId;
  String? postReportedBy;
  String? reportReasonText;
  String? reportedTo;
  String? contentType;
  Timestamp? timestamp;
  String? postId;
  String? adminId;
  String? postTitle;
  String? postDescription;
  String? reportedToUserName;

  ReportPostModel({
    this.contentType,
    this.reportId,
    this.reportReasonText,
    this.postTitle,
    this.postDescription,
    this.postId,
    this.postReportedBy,
    this.reportedToUserName,
    this.reportedTo,
    this.adminId,
    this.timestamp,
  });
  Map<String, dynamic> toMap() {
    return {
      "reportId": reportId ?? "",
      "postReportedBy": postReportedBy ?? "",
      "reportedTo": reportedTo ?? "",
      "reportReasonText": reportReasonText ?? "",
      "contentType": contentType ?? "",
      "timeStamp": FieldValue.serverTimestamp(),
      "postId": postId ?? "",
      'adminId': adminId ?? "",
      'postTitle': postTitle ?? "",
      'postDescription': postDescription ?? "",
      "reportedToUserName": reportedToUserName ?? "",
    };
  }

  factory ReportPostModel.fromMap(Map<String, dynamic> json) {
    final createdAtField = json['timeStamp'];
    return ReportPostModel(
      reportId: json['reportId'],
      reportReasonText: json['reportReasonText'],
      postReportedBy: json['postReportedBy'],
      reportedTo: json['reportedTo'],
      timestamp: createdAtField is Timestamp ? json['timeStamp'] : null,
      contentType: json['contentType'],
      adminId: json['adminId'] ?? "",
      postTitle: json['postTitle'] ?? "",
      reportedToUserName: json["reportedToUserName"] ?? "",
      postDescription: json['postDescription'] ?? "",
      postId: json['postId'] ?? "",
    );
  }
  @override
  String toString() {
    return 'ReportPostModel('
        'reportId:$reportId, '
        'postReportedBy:$postReportedBy, '
        'reportedTo:$reportedTo, '
        'reportReasonText:$reportReasonText, '
        'timeStamp:$timestamp, '
        'contentType:$contentType, '
        'postId:$postId, '
        'adminId:$adminId, '
        'postTitle:$postTitle, '
        'postDescription:$postDescription, '
        'reportedToUserName:$reportedToUserName, '
        ')';
  }
}
