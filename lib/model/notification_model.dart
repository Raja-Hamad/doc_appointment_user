class NotificationModel {
  final String userId;
  final String notificationTitle;
  final String notificationBody;
  final String doctorImageUrl;
  final String doctorName;
  final String doctorSpecfication;
  final String id;
  final String appointmentId;
  final String patientName;
  final String appointmentStatus;
  final String adminId;
  NotificationModel({
    required this.doctorImageUrl,
    required this.doctorName,
    required this.doctorSpecfication,
    required this.appointmentId,
    required this.id,
    required this.notificationBody,
    required this.appointmentStatus,
    required this.adminId,
    required this.patientName,
    required this.notificationTitle,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "notificationTitle": notificationTitle,
      "patientName": patientName,
      "appointmentStatus": appointmentStatus,
      "notificationBody": notificationBody,
      "userId": userId,
      "doctorImageUrl": doctorImageUrl,
      "doctorName": doctorName,
      "doctorSpecfication": doctorSpecfication,
      "adminId":adminId,
      "appointmentId": appointmentId,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      appointmentStatus: json['appointmentStatus'],
      adminId: json['adminId'],
      patientName: json['patientName'],
      doctorImageUrl: json['doctorImageUrl'],
      doctorName: json['doctorName'],
      doctorSpecfication: json['doctorSpecfication'],
      appointmentId: json['appointmentId'],
      id: json['id'],
      notificationBody: json['notificationBody'],
      notificationTitle: json['notificationTitle'],
      userId: json['userId'],
    );
  }
  @override
String toString() {
  return 'NotificationModel('
      'userId: $userId, '
      'notificationTitle: $notificationTitle, '
      'notificationBody: $notificationBody, '
      'doctorImageUrl: $doctorImageUrl, '
      'doctorName: $doctorName, '
      'doctorSpecfication: $doctorSpecfication, '
      'id: $id, '
      'appointmentId: $appointmentId, '
      'patientName: $patientName, '
      'appointmentStatus: $appointmentStatus, '
      'adminId: $adminId'
      ')';
}

}
