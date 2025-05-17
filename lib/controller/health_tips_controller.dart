import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_appointment_user/model/health_tip_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HealthTipsController extends GetxController {
  RxList<HealthTipModel> healthTipsList = <HealthTipModel>[].obs;

  void listenToHealthTips() {
    FirebaseFirestore.instance
        .collection('health_tips')
        .orderBy('datePosted', descending: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
          healthTipsList.value =
              snapshot.docs
                  .map(
                    (doc) => HealthTipModel.fromJson(
                      doc.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList();
        });
  }
}
