import 'package:doctor_appointment_user/services/firestore_services.dart';
import 'package:get/get.dart';
import '../model/feedback_model.dart';

class FeedbackController extends GetxController {
  final FirestoreServices _service = FirestoreServices();
var isLoading=false.obs;
  Future<void> submitFeedbackResponse({
    required String question,
    required FeedbackResponseModel response,
  }) async {
    isLoading.value=true;
    await _service.submitFeedback(question, response);
    isLoading.value=false;
  }
}
