// lib/data/repositories/auth_repository.dart
import 'package:dio/dio.dart';
import 'package:wave_app/data/models/user_model.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'YOUR_API_URL',
    contentType: 'application/json',
  ));

  Future<UserModel> login(String phone, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'phone': phone,
        'password': password,
      });
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> register(String name, String phone, String email, String password) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
      });
      return UserModel.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data != null && e.response?.data['message'] != null) {
      return e.response?.data['message'];
    }
    return 'Une erreur est survenue. Veuillez réessayer.';
  }
}