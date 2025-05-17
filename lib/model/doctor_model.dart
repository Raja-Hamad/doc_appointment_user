import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorModel {
  final String id;
  final String adminId;
  final String name;
  final String specialization;
  final String imageUrl;
  final String aboutDoctor;
  final String adminDeviceToken;
  List<String>? availableTimeSlots;
  List<String>? availableDays;
  Timestamp? timestamp;

  DoctorModel({
    required this.id,
    required this.aboutDoctor,
    required this.adminId,
    required this.name,
    required this.adminDeviceToken,
    required this.specialization,
    required this.imageUrl,
    this.availableDays,
    this.availableTimeSlots,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adminId': adminId,
      "aboutDoctor": aboutDoctor,
      'adminDeviceToken': adminDeviceToken,
      'name': name,
      'specialization': specialization,
      'imageUrl': imageUrl,
      "availableTimeSlots": availableTimeSlots ?? [],
      "availableDays": availableDays ?? [],
      "timeStamp": FieldValue.serverTimestamp(),
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    final createdAt = map['timeStamp'];

    return DoctorModel(
      aboutDoctor: map['aboutDoctor'],
      adminDeviceToken: map['adminDeviceToken'],
      id: map['id'] ?? '',
      adminId: map['adminId'] ?? '',
      name: map['name'] ?? '',
      specialization: map['specialization'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      availableDays: List<String>.from(map['availableDays'] ?? []),
      availableTimeSlots: List<String>.from(map['availableTimeSlots'] ?? []),

      timestamp: createdAt is Timestamp ? map['timeStamp'] : null,
    );
  }
  @override
  String toString() {
    return 'DoctorModel('
        'id:$id, '
        'adminId:$adminId, '
        'availableDays:$availableDays, '
        'availableTimeSlots:$availableTimeSlots, '
        'name:$name, '
        'timestamp:$timestamp, '
        'specialization:$specialization, '
        'imageUrl:$imageUrl, '
        'aboutDoctor:$aboutDoctor, '
        'adminDeviceToken:$adminDeviceToken, '
        ')';
  }
}
