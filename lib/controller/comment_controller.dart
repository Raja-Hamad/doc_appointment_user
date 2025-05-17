import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/model/comment_model.dart';
import 'package:doctor_appointment_user/services/firestore_services.dart';
import 'package:doctor_appointment_user/utils/extensions/another_flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CommentController extends GetxController {
  final FirestoreServices _firestoreService = FirestoreServices();
  var isLoading = false.obs;
  RxString commentText = ''.obs;
  var commentController = TextEditingController().obs;
  RxString commentId = ''.obs;
  RxString adminId=''.obs;
  Future<void> addComment(
    BuildContext context,
    String postId,
    String commenterImageUrl,
    String commenterName,
    String commenterPhone
  ) async {
    try {
      isLoading.value = true;
      CommentModel model = CommentModel(
        commenterPhone: commenterPhone,
        adminId: adminId.value,
        postId: postId,
        commentId: Uuid().v4(),
        commentText: commentText.value,
        commenterId: FirebaseAuth.instance.currentUser!.uid,
        commenterImageUrl: commenterImageUrl,
        commenterName: commenterName,
      );
      final createdAt = model.toMap();
      createdAt['timeStamp'] =
          FieldValue.serverTimestamp(); // Add timestamp manually
      await _firestoreService.addComment(model, context);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        FlushBarMessages.errorMessageFlushBar(
          "Error while uploading the comment ${e.toString()}",
          context,
        );
        print("Error while uplaoding the comment ${e.toString()}");
        throw Exception(e.toString());
      }
    }
  }

  Future<void> deleteComment(BuildContext context) async {
    try {
      isLoading.value = true;
      await _firestoreService.deleteComment(commentId.value, context);
      isLoading.value = false;
      FlushBarMessages.successMessageFlushBar(
        "Successfully deleted comment",
        context,
      );
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        FlushBarMessages.errorMessageFlushBar(
          "Error while delelting the comment ${e.toString()}",
          context,
        );
        print("Error while deleting the comment ${e.toString()}");
        throw Exception(e.toString());
      }
    }
  }
}
