// lib/controllers/all_doctors_controller.dart
import 'package:get/get.dart';
import '../model/doctor_model.dart';
import '../services/firestore_services.dart';

class AllDoctorsController extends GetxController {
  final FirestoreServices _firestoreServices = FirestoreServices();

  var doctorList = <DoctorModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchDoctors();
    super.onInit();
  }

  Future<void> fetchDoctors() async {
    isLoading.value = true;
    final result = await _firestoreServices.getDoctorsByAdminId();
    doctorList.assignAll(result);
    isLoading.value = false;
  }
}
