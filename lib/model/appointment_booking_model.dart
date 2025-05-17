class AppointmentBookingModel {
  final String id;
  final String doctorName;
  final String doctorId;
  final String adminId;
  final String doctoImageUrl;
  final String patientName;
  final String number;
  final String userId;
  final String specialization;
  final String aboutDoctor;

  final String createdAt;
  final String bookingType;
  final String notes;
  final String bookingStatus;
  final String userDeviceToken;
  final String selectedTimeSlot;
  final String selectedDay;
  AppointmentBookingModel({
    required this.id,
    required this.aboutDoctor,
    required this.userDeviceToken,
    required this.doctoImageUrl,
    required this.adminId,
    required this.specialization,

    required this.bookingStatus,
    required this.selectedDay,
    required this.selectedTimeSlot,
    required this.bookingType,
    required this.createdAt,
    required this.doctorId,
    required this.doctorName,
    required this.notes,
    required this.number,
    required this.patientName,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorName': doctorName,
      'doctorId': doctorId,
      'doctoImageUrl': doctoImageUrl,
      'patientName': patientName,
      'number': number,
      'userId': userId,
      'specialization': specialization,
      "userDeviceToken": userDeviceToken,
      'aboutDoctor': aboutDoctor,

      'createdAt': createdAt,
      'adminId': adminId,
      'bookingType': bookingType,
      'notes': notes,
      'bookingStatus': bookingStatus,
      'selectedTimeSlot': selectedTimeSlot.toString(),
      "selectedDay": selectedDay.toString(),
    };
  }

  factory AppointmentBookingModel.fromJson(Map<String, dynamic> json) {
    return AppointmentBookingModel(
      userDeviceToken: json['userDeviceToken'],
      id: json['id'] ?? '',
      adminId: json['adminId'] ?? '',
      doctorName: json['doctorName'] ?? '',
      doctorId: json['doctorId'] ?? '',
      doctoImageUrl: json['doctoImageUrl'] ?? '',
      patientName: json['patientName'] ?? '',
      number: json['number'] ?? '',
      userId: json['userId'] ?? '',
      specialization: json['specialization'] ?? '',
      aboutDoctor: json['aboutDoctor'] ?? '',

      createdAt: json['createdAt'] ?? '',
      bookingType: json['bookingType'] ?? '',
      notes: json['notes'] ?? '',
      bookingStatus: json['bookingStatus'] ?? '',
      selectedDay: json['selectedDay'] ?? "",
      selectedTimeSlot: json['selectedTimeSlot'] ?? '',
    );
  }
  @override
  String toString() {
    return '''
AppointmentBookingModel {
  id: $id,
  doctorName: $doctorName,
  doctorId: $doctorId,
  doctoImageUrl: $doctoImageUrl,
  patientName: $patientName,
  number: $number,
  adminId:$adminId,
  userId: $userId,
  specialization: $specialization,
  aboutDoctor: $aboutDoctor,

  userDeviceToken:$userDeviceToken,
  createdAt: $createdAt,
  bookingType: $bookingType,
  notes: $notes,
  bookingStatus: $bookingStatus,
  selectedDay:$selectedDay,
  selectedTimeSlot:$selectedTimeSlot
}''';
  }
}
