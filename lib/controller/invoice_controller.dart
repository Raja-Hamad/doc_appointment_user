import 'package:doctor_appointment_user/model/invoice_model.dart';
import 'package:doctor_appointment_user/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class InvoiceController extends GetxController {
  final FirestoreServices _firestoreServices = FirestoreServices();
  RxList<InvoiceModel> invoices = <InvoiceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    _firestoreServices.getInvoicesStream(userId).listen((data) {
      invoices.value = data;
    });
  }
}
