import 'package:cloud_firestore/cloud_firestore.dart';

class ReportCommentModel {
  String? reportId;
  String? reportedBy;
  String? reportReasonText;
  String? reportedTo;
  String? contentType;
  Timestamp? timestamp;
  String? commentId;
  String? adminId;
  String? postTitle;
  String? postDescription;
  String? commentText;
  String? commenterName;
  String commenterPhone;
  String? commenterImageUrl;
  String? reporterName;
  String? reporterImageurl;
  String? reporterPhoneNumber;
  ReportCommentModel({
    this.contentType,
    this.reportId,
    this.reportReasonText,
    this.commentText,
    this.postTitle,
    this.reportedBy,
    this.reportedTo,
    this.commenterImageUrl,
    this.reporterImageurl,
    this.reporterName,
    this.reporterPhoneNumber,
    this.commenterName,
    required this.commenterPhone,
    this.postDescription,
    this.commentId,
    this.adminId,
    this.timestamp,
  });
  Map<String, dynamic> toMap() {
    return {
      "reportId": reportId ?? "",
      "reportedBy": reportedBy ?? "",
      "reportedTo": reportedTo ?? "",
      "reportReasonText": reportReasonText ?? "",
      "contentType": contentType ?? "",
      "timeStamp": FieldValue.serverTimestamp(),
      "commentId": commentId ?? "",
      'adminId': adminId ?? "",
      'postTitle': postTitle ?? "",
      'commentText': commentText ?? "",
      "commenterName": commenterName ?? "",
      'commenterPhone': commenterPhone,
      'commenterImageUrl': commenterImageUrl ?? "",
      'reporterName': reporterName ?? "",
      "reporterImageUrl": reporterImageurl ?? "",
      "reporterPhoneNumber": reporterPhoneNumber,
      'postDescription': postDescription ?? "",
    };
  }

  factory ReportCommentModel.fromMap(Map<String, dynamic> json) {
    final createdAtField = json['timeStamp'];
    return ReportCommentModel(
      reportId: json['reportId'],
      reportReasonText: json['reportReasonText'],
      reportedBy: json['reportedBy'],
      reportedTo: json['reportedTo'],
      timestamp: createdAtField is Timestamp ? json['timeStamp'] : null,
      contentType: json['contentType'],
      commenterPhone: json['commenterPhone'],
      commentId: json['commentId'] ?? "",
      adminId: json['adminId'] ?? "",
      postTitle: json['postTitle'] ?? "",
      commentText: json['commentText'] ?? "",
      commenterName: json['commenterName'] ?? "",
      commenterImageUrl: json['commenterImageUrl'] ?? "",
      reporterPhoneNumber: json['reporterPhoneNumber'] ?? "",
      reporterImageurl: json['reporterImageUrl'] ?? "",
      reporterName: json['reporterName'] ?? "",
      postDescription: json['postDescription'] ?? "",
    );
  }
  @override
  String toString() {
    return 'ReportCommentModel('
        'reportId:$reportId, '
        'reportedBy:$reportedBy, '
        'reportedTo:$reportedTo, '
        'reportReasonText:$reportReasonText, '
        'timeStamp:$timestamp, '
        'contentType:$contentType, '
        'commentId:$commentId, '
        'adminId:$adminId, '
        'postTitle:$postTitle, '
        'commentText:$commentText, '
        'commenterName:$commenterName, '
        'commenterPhone:$commenterPhone, '
        'commenterImageUrl:$commenterImageUrl, '
        'reporterName:$reporterName, '
        'reporterImageUrl:$reporterImageurl, '
        'reporterPhoneNumber:$reporterPhoneNumber, '
        'postDescription:$postDescription, '
        ')';
  }
}
