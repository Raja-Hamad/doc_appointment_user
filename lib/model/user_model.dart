class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String userDeviceToken;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userDeviceToken,
    required this.role,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      "userDeviceToken": userDeviceToken,
      "role": role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      role: map['role'],
      userDeviceToken: map['userDeviceToken'],
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
  @override
  String toString() {
    return 'UserModel('
        'id: $id, '
        'name: $name, '
        'email: $email, '
        'password: $password, '
        'userDeviceToken: $userDeviceToken, '
        'role: $role, '
        ')';
  }
}
