import 'package:dio/dio.dart';
import 'package:wave_app/data/models/user_model.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository({String? baseUrl}) : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? 'https://api.yourdomain.com/v1', // Remplacez par l'URL de votre API
      contentType: 'application/json',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      validateStatus: (status) => status! < 500,
    ),
  );

  Future<UserModel> login(String phone, String password) async {
    return _performAuthRequest(
      '/auth/login',
      data: {
        'phone': phone,
        'password': password,
      },
      successStatus: 200,
    );
  }

  Future<UserModel> register(String name, String phone, String email, String password) async {
    return _performAuthRequest(
      '/auth/register',
      data: {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
      },
      successStatus: 201,
    );
  }

  Future<UserModel> _performAuthRequest(String endpoint, {required Map<String, dynamic> data, required int successStatus}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      
      if (response.statusCode == successStatus) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw _handleError(DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ));
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'La connexion au serveur a échoué. Veuillez vérifier votre connexion internet.';
      case DioExceptionType.badResponse:
        return e.response?.data['message'] ?? 'Une erreur est survenue (${e.response?.statusCode}). Veuillez réessayer.';
      case DioExceptionType.cancel:
        return 'La requête a été annulée.';
      default:
        return 'Une erreur inattendue est survenue. Veuillez réessayer.';
    }
  }
}
