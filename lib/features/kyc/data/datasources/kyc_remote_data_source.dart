import '../../domain/entities/kyc_document.dart';
import '../../domain/entities/kyc_status.dart';

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
