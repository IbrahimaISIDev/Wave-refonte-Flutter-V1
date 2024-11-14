// lib/services/dio_service.dart

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioService {
  static const String baseUrl = 'http://192.168.6.82:3000/api';
  //static const String baseUrl = 'https://flutter-laravel-wave-app.onrender.com/api';

  static const String tokenKey = 'auth_token';
  
  static final DioService instance = DioService._internal();
  String? _authToken;
  
  DioService._internal();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(tokenKey);
  }

  Dio getDio({
    Duration connectTimeout = const Duration(seconds: 5),
    Duration receiveTimeout = const Duration(seconds: 20),
    bool addAuthHeader = true,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        contentType: 'application/json',
        headers: {
          'Accept': 'application/json',
          if (addAuthHeader && _authToken != null)
            'Authorization': 'Bearer $_authToken',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Add logging interceptor
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        logPrint: (log) => print('DIO LOG - $log'),
      ),
    );

    // Add auth error interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Handle token expiration here
            // You could emit a global event to trigger logout
            print('Token expired or invalid');
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<void> clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }

  String? get authToken => _authToken;
}