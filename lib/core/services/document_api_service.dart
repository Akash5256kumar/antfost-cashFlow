import 'dart:io';

import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import 'api_client.dart';

class DocumentApiService {
  DocumentApiService(this._client);
  final ApiClient _client;

  Future<Map<String, dynamic>> requestUploadUrl({
    required String documentType,
    required String fileName,
    required String mimeType,
    required int fileSizeBytes,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        '/kyc/document-upload-urls',
        data: {
          'documentType': documentType,
          'fileName': fileName,
          'mimeType': mimeType,
          'fileSizeBytes': fileSizeBytes,
        },
      );
      if (response.data == null)
        throw const ServerException('Upload URL response is invalid.');
      return response.data!;
    } on DioException catch (e) {
      throw _error(e, 'Unable to prepare document upload.');
    }
  }

  Future<void> uploadFile(
    String uploadUrl,
    String path,
    String mimeType,
  ) async {
    try {
      // Use the shared client even for the raw upload. The v1.1 upload URL is
      // an API endpoint and still requires the current bearer token.
      await _client.dio.put<void>(
        uploadUrl,
        data: await File(path).readAsBytes(),
        options: Options(headers: {'Content-Type': mimeType}),
      );
    } on DioException catch (e) {
      throw _error(e, 'Document upload failed.');
    }
  }

  Future<List<Map<String, dynamic>>> list({String? documentType}) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        '/documents',
        queryParameters: {
          if (documentType != null) 'documentType': documentType,
        },
      );
      final items = response.data?['items'];
      if (items is! List)
        throw const ServerException('Documents response is invalid.');
      return items.whereType<Map>().map(Map<String, dynamic>.from).toList();
    } on DioException catch (e) {
      final data = e.response?.data;
      if (e.response?.statusCode == 404 &&
          data is Map &&
          data['code'] == 'NO_DOCUMENTS_FOUND') {
        return const [];
      }
      throw _error(e, 'Unable to load documents.');
    }
  }

  Future<Map<String, dynamic>> create({
    required String type,
    required String fileId,
    String? expiryDate,
  }) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        '/documents',
        data: {
          'type': type,
          'fileId': fileId,
          if (expiryDate != null) 'expiryDate': expiryDate,
        },
      );
      if (response.data == null)
        throw const ServerException('Document response is invalid.');
      return response.data!;
    } on DioException catch (e) {
      throw _error(e, 'Unable to save document.');
    }
  }

  Future<void> delete(String documentId) async {
    try {
      await _client.delete<void>('/documents/$documentId');
    } on DioException catch (e) {
      throw _error(e, 'Unable to delete document.');
    }
  }

  ServerException _error(DioException e, String fallback) {
    final data = e.response?.data;
    return ServerException(
      data is Map && data['message'] is String
          ? data['message'] as String
          : e.message ?? fallback,
    );
  }
}
