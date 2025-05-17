import 'package:doctor_appointment_user/services/firestore_services.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SurveyController extends GetxController {
  final FirestoreServices _firestoreServices = FirestoreServices();
  var isLoading = false.obs;
  var answerController = TextEditingController().obs;
  Future<void> uploadReponse(Map<String,dynamic> data, String questionId, String surveyId,BuildContext context)async{
    try{
      isLoading.value=true;
      await _firestoreServices.uploadReponse(data, questionId, surveyId, context);
isLoading.value=false;
    }
    catch(e){
      isLoading.value=false;
    }
  }
}
