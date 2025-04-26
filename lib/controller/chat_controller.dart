import 'package:doctor_appointment_user/services/firestore_services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController extends GetxController {
  final FirestoreServices _chatService = FirestoreServices();
  RxList<DocumentSnapshot> messages = <DocumentSnapshot>[].obs;

  Stream<QuerySnapshot>? messageStream;

  void startChatStream(String currentUserId, String adminId) {
    messageStream = _chatService.getMessages(currentUserId, adminId);
    messageStream!.listen((event) {
      messages.value = event.docs;
    });
  }

  Future<void> sendMessage(String currentUserId, String adminId, String message) async {
    await _chatService.sendMessage(currentUserId, adminId, message);
  }
}
