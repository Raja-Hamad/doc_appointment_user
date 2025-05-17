class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String phone;
  final String gender;
  final String address;
  final String dob;
  final String imageUrl;

  final String userDeviceToken;
  UserModel({
    required this.id,
    required this.userDeviceToken,
    required this.name,
    required this.email,
    required this.role,
    required this.password,
    required this.address,
    required this.dob,
    required this.gender,
    required this.imageUrl,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      "userDeviceToken": userDeviceToken,
      'password': password,
      "role": role,
      "phone": phone,
      'address': address,
      'imageUrl': imageUrl,
      'dob': dob,
      'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userDeviceToken: map['userDeviceToken'],
      role: map['role'],
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      phone: map['phone'] ?? '',
      gender: map['gender'] ?? '',
      dob: map['dob'] ?? '',
      address: map['address'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
