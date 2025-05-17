import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityPostModel {
  String? postId;
  String? postTitle;
  String? postDescription;
  String? adminId;
  String? adminName;
  String? adminImageUrl;
  Timestamp? createdAt;
  CommunityPostModel({
    this.adminId,
    this.adminImageUrl,
    this.adminName,
    this.createdAt,
    this.postDescription,
    this.postId,
    this.postTitle,
  });
  Map<String, dynamic> toMap() {
    return {
      "postId": postId ?? "",
      "adminId": adminId ?? "",
      "postTitle": postTitle ?? "",
      "postDescription": postDescription ?? "",
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
      "adminName": adminName ?? "",
      "adminImageUrl": adminImageUrl ?? "",
    };
  }

  factory CommunityPostModel.fromMap(Map<String, dynamic> map) {
    final createdAtField = map['createdAt'];
    return CommunityPostModel(
      createdAt: createdAtField is Timestamp ? createdAtField : null,
      adminId: map['adminId'],
      adminImageUrl: map['adminImageUrl'],
      adminName: map['adminName'],
      postDescription: map['postDescription'],
      postId: map['postId'],
      postTitle: map['postTitle'],
    );
  }
  @override
  String toString() {
    return 'CommunityPostModel('
        'postId:$postId, '
        'adminId:$adminId, '
        'postTitle:$postTitle, '
        'postDescription:$postDescription, '
        'createdAt:$createdAt, '
        'adminName:$adminName, '
        'adminImageUrl:$adminImageUrl, '
        ')';
  }
}
