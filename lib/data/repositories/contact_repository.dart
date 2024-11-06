import 'package:dio/dio.dart';
import 'package:wave_app/data/models/contact_model.dart';

class ContactRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'YOUR_API_URL',
    contentType: 'application/json',
  ));

  Future<List<ContactModel>> getContacts() async {
    try {
      final response = await _dio.get('/contacts');
      return (response.data as List)
          .map((contact) => ContactModel.fromJson(contact))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ContactModel> createContact(String name, String phone) async {
    try {
      final response = await _dio.post('/contacts', data: {
        'name': name,
        'phone': phone,
      });
      return ContactModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ContactModel> updateContact(int id, String name, String phone) async {
    try {
      final response = await _dio.put('/contacts/$id', data: {
        'name': name,
        'phone': phone,
      });
      return ContactModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteContact(int id) async {
    try {
      await _dio.delete('/contacts/$id');
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
