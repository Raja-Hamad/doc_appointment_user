import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? commentId;
  String? commentText;
  String? commenterId;
  String? commenterName;
  String? commenterImageUrl;
  String? postId;
  Timestamp? timestamp;
  String  commenterPhone;
  String? adminId;
  CommentModel({
    this.commentId,
    this.commentText,
    this.commenterId,
    this.commenterImageUrl,
    this.commenterName,
    required this.commenterPhone,
    this.adminId,
    this.postId,
    this.timestamp,
  });
  Map<String, dynamic> toMap() {
    return {
      "commentId": commentId ?? "",
      "commenterId": commenterId ?? "",
      "commentText": commentText ?? "",
      'adminId': adminId ?? "",
      "commenterName": commenterName ?? "",
      "commenterImageUrl": commenterImageUrl ?? "",
      "postId": postId ?? "",
      "timeStamp": FieldValue.serverTimestamp(),
      "commenterPhone":commenterPhone
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> json) {
    final createdAtField = json['timeStamp'];
    return CommentModel(
      postId: json['postId'],
      commentId: json['commentId'],
      commentText: json['commentText'],
      commenterId: json['commenterId'],
      commenterImageUrl: json['commenterImageUrl'],
      commenterName: json['commenterName'],
      timestamp: createdAtField is Timestamp ? json['timeStamp'] : null,
      commenterPhone: json['commenterPhone'],
      adminId: json['adminId'] 
    );
  }
  @override
  String toString() {
    return 'CommentModel('
        'postId:$postId, '
        'commentId:$commentId, '
        'commenterId:$commenterId, '
        'commenterImageUrl:$commenterId, '
        'commenterName:$commenterName, '
        'commenterId:$commenterId, '
        'timeStamp:$timestamp, '
        'adminId:$adminId, '
        'commenterPhone:$commenterPhone, '
        ')';
  }
}
