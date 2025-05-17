class InvoiceModel {
  String ? id;
  String ? userId;
  String ? appointmentId;
  String ? consultationFee;
  String ? medicinesFee;
  String ? totalFee;
  String ? feeDiscount;
  String ? paidStatus;
  String ? paymentMethod;
  String ? doctorId;
  String ? adminId;
  String ? patientName;
  String ? patientContactNumber;
  String ? bookingType;
  String ? bookingStatus;
  String ? doctorImageUrl;
  String ? appointmentDate;
  String ? appointmentTime;
  String ? doctorName;
  String ? doctorSpecfication;
  String ? doctorAbout;
  String ? notes;

  InvoiceModel({
    this.adminId,
    this.doctorAbout,
    this.notes,
    this.doctorName,
    this.doctorSpecfication,
    this.appointmentId,
    this.consultationFee,
    this.doctorId,
    
    this.appointmentDate,
    this.appointmentTime,
    this.bookingStatus,
    this.bookingType,
    this.doctorImageUrl,
    this.patientContactNumber,
    this.feeDiscount,
    this.id,
    this.medicinesFee,
    this.paidStatus,
    this.patientName,
    this.paymentMethod,
    this.totalFee,
    this.userId
  });

  Map<String,dynamic> toJson(){
    return{
      "id":id ?? "",
      'notes': notes ?? "",
      "userId": userId ?? "",
      "patientName": patientName ?? "",
      "consultationFee":consultationFee ?? "",
      "medicinesFee":medicinesFee ?? "",
      "totalFee":totalFee ?? "",
      "feeDiscount":feeDiscount ?? "",
      "doctorId":doctorId ?? "",
      "adminId":adminId ?? "",
      "appointmentId":appointmentId ?? "",
      'paymentMethod':paymentMethod ?? "",
      "paidStatus":paidStatus ?? "",
      "patientContactNumber":patientContactNumber ?? "",
      "bookingType":bookingType ?? "",
      "bookingStatus":bookingStatus ?? "",
      "doctorImageUrl":doctorImageUrl ?? "",
      "appointmentDate":appointmentDate ?? "",
      "appointmentTime":appointmentTime ?? "",
      "doctorName":doctorName ?? "",
      "doctorSpecfication":doctorSpecfication ?? "",
      "doctorAbout":doctorAbout ?? ""


    };
  }

  factory InvoiceModel.fromJson(Map<String,dynamic> json){
    return InvoiceModel(
      id: json['id'],
      notes: json['notes'],
      userId: json['userId'],
      appointmentId: json['appointmentId'],
      adminId: json['adminId'],
      doctorId: json['doctorId'],
      paidStatus: json['paidStatus'],
      patientName: json['patientName'],
      paymentMethod: json['paymentMethod'],
      patientContactNumber:json['patientContactNumber'],
      feeDiscount: json['feeDiscount'],
      totalFee: json['totalFee'],
      medicinesFee: json['medicinesFee'],
      consultationFee: json['consultationFee'],
      appointmentDate: json['appointmentDate'],
      appointmentTime: json['appointmentTime'],
      bookingStatus: json['bookingStatus'],
      bookingType: json['bookingType'],
      doctorImageUrl: json['doctorImageUrl'],
      doctorSpecfication:json['doctorSpecfication'],
      doctorAbout: json['doctorAbout'],
      doctorName: json['doctorName']

    );
  }
@override
String toString() {
  return 'InvoiceModel('
      'id: $id, '
      'userId: $userId, '
      'appointmentId: $appointmentId, '
      'consultationFee: $consultationFee, '
      'medicinesFee: $medicinesFee, '
      'totalFee: $totalFee, '
      'notes:$notes, '
      'feeDiscount: $feeDiscount, '
      'paidStatus: $paidStatus, '
      'paymentMethod: $paymentMethod, '
      'doctorId: $doctorId, '
      'adminId: $adminId, '
      'patientName: $patientName, '
      'patientContactNumber: $patientContactNumber, '
      'bookingType: $bookingType, '
      'bookingStatus: $bookingStatus, '
      'doctorImageUrl: $doctorImageUrl, '
      'appointmentDate: $appointmentDate, '
      'appointmentTime: $appointmentTime, '
      'doctorName: $doctorName, '
      'doctorSpecfication: $doctorSpecfication, '
      'doctorAbout: $doctorAbout'
      ')';
}



}