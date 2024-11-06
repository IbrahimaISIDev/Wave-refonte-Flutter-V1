// lib/data/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String token;
  final String createdAt;
  final String updatedAt;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.token,
    required this.createdAt,
    required this.updatedAt,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      name: data['name'],
      phone: data['phone'],
      email: data['email'],
      token: data['token'],
      createdAt: data['created_at'],
      updatedAt: data['updated_at'],
      isAdmin: data['isAdmin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'token': token,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'isAdmin': isAdmin,
    };
  }
}