import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import 'api_client.dart';

class CompanyApiService {
  CompanyApiService(this._client);
  final ApiClient _client;
  Future<Map<String, dynamic>> getCompany() => _request(() async {
    final response = await _client.get<Map<String, dynamic>>('/company');
    if (response.data == null) throw const ServerException('Company response is invalid.');
    return response.data!;
  });
  Future<void> saveCompany(Map<String, dynamic> data) => _request(() async {
    final response = await _client.dio.put<Map<String, dynamic>>('/company', data: data);
    if (response.data == null) throw const ServerException('Company update response is invalid.');
  });
  Future<T> _request<T>(Future<T> Function() fn) async { try { return await fn(); } on DioException catch (e) { final d=e.response?.data; throw ServerException(d is Map && d['message'] is String ? d['message'] as String : e.message ?? 'Unable to update company information.'); } }
}
