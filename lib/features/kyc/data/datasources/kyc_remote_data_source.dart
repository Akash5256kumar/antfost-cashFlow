import '../../domain/entities/kyc_document.dart';
import '../../domain/entities/kyc_status.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import 'package:dio/dio.dart';

/// Contract for the remote KYC data source.
abstract class KycRemoteDataSource {
  /// Fetches the current KYC verification status from the remote API.
  Future<KycStatus> getKycStatus();

  /// Submits KYC documents and applicant information to the remote API.
  ///
  /// Returns `true` on a successful submission.
  Future<bool> submitKyc({
    required List<KycDocument> documents,
    required String fullName,
    required String emiratesId,
    required String tradeListNumber,
  });
}

// ---------------------------------------------------------------------------
// Mock implementation — replace with Dio/Retrofit once the API is ready.
// ---------------------------------------------------------------------------

/// Simulates a 300 ms network round-trip for status fetch operations.
Future<void> _fakeDelay() => Future.delayed(const Duration(milliseconds: 300));

/// Simulates an 800 ms network round-trip for document submission.
Future<void> _fakeSubmitDelay() =>
    Future.delayed(const Duration(milliseconds: 800));

/// Mock remote data source for development / testing purposes.
class MockKycRemoteDataSource implements KycRemoteDataSource {
  @override
  Future<KycStatus> getKycStatus() async {
    await _fakeDelay();

    // Simulate a user who has already submitted their KYC and is pending review.
    return const KycStatus(
      status: KycVerificationStatus.pending,
      submittedAt: '1 Feb 2026 10:00 AM',
    );
  }

  @override
  Future<bool> submitKyc({
    required List<KycDocument> documents,
    required String fullName,
    required String emiratesId,
    required String tradeListNumber,
  }) async {
    await _fakeSubmitDelay();
    return true;
  }
}

class ApiKycRemoteDataSource implements KycRemoteDataSource {
  ApiKycRemoteDataSource(this._client);
  final ApiClient _client;
  @override
  Future<KycStatus> getKycStatus() async {
    try {
      final response = await _client.get<Map<String, dynamic>>('/kyc/status');
      final data = response.data;
      if (data == null)
        throw const ServerException('KYC status response is invalid.');
      final status = switch (data['status']) {
        'approved' => KycVerificationStatus.approved,
        'rejected' => KycVerificationStatus.rejected,
        'pending' => KycVerificationStatus.pending,
        _ => KycVerificationStatus.notSubmitted,
      };
      return KycStatus(
        status: status,
        submittedAt: data['submittedAt'] as String?,
        reviewedAt: data['reviewedAt'] as String?,
        rejectionReason: data['rejectionReason'] as String?,
      );
    } on DioException catch (error) {
      final data = error.response?.data;
      throw ServerException(
        data is Map && data['message'] is String
            ? data['message'] as String
            : error.message ?? 'Unable to load KYC status.',
      );
    }
  }

  @override
  Future<bool> submitKyc({
    required List<KycDocument> documents,
    required String fullName,
    required String emiratesId,
    required String tradeListNumber,
  }) async {
    throw const ServerException(
      'KYC upload requires server-issued document upload URLs.',
    );
  }
}
