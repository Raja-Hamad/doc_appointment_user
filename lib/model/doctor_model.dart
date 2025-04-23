class DoctorModel {
  final String id;
  final String adminId;
  final String name;
  final String specialization;
  final String imageUrl;
    final String aboutDoctor;
    final String adminDeviceToken;

  DoctorModel({
    required this.id,
    required this.aboutDoctor,
    required this.adminId,
    required this.name,
    required this.adminDeviceToken,
    required this.specialization,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adminId': adminId,
      "aboutDoctor":aboutDoctor,
      "adminDeviceToken":adminDeviceToken,
      'name': name,
      'specialization': specialization,
      'imageUrl': imageUrl,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      adminDeviceToken: map['adminDeviceToken'],
      aboutDoctor: map['aboutDoctor'],
      id: map['id'] ?? '',
      adminId: map['adminId'] ?? '',
      name: map['name'] ?? '',
      specialization: map['specialization'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
