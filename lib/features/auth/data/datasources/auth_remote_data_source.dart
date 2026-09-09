import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Contract for the remote authentication data source.
abstract class AuthRemoteDataSource {
  /// Returns a [UserModel] on successful sign-in.
  /// Throws [AuthException] on invalid credentials.
  Future<UserModel> signIn({
    required String contact,
    required String passcode,
    required bool isEmail,
  });

  /// Returns a [UserModel] representing the newly created account.
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String phone,
    required String company,
    required String passcode,
  });

  /// Returns `true` when the OTP is accepted.
  Future<bool> verifyOtp({
    required String contact,
    required String otp,
    required bool isEmail,
  });

  /// Returns `true` when the OTP has been dispatched to [contact].
  Future<bool> forgotPasscode({required String contact, required bool isEmail});

  /// Returns `true` when the passcode has been reset successfully.
  Future<bool> resetPasscode({
    required String contact,
    required String otp,
    required String newPasscode,
  });

  /// Returns `true` on successful remote sign-out.
  Future<bool> signOut();
}

// ---------------------------------------------------------------------------
// Mock implementation — replace with Dio/Retrofit once the API is ready.
// ---------------------------------------------------------------------------

/// Dummy credentials accepted by the mock:
///   - email  : test@test.com  | passcode: 123456
///   - phone  : 0501234567     | passcode: 123456
const _mockEmail = 'test@test.com';
const _mockPhone = '0501234567';

/// Simulates a 300 ms network round-trip.
Future<void> _fakeDelay() => Future.delayed(const Duration(milliseconds: 300));

/// A pre-built dummy user returned by all successful mock calls.
final _dummyUser = UserModel(
  id: 'usr_001',
  name: 'Akash Kumar',
  email: _mockEmail,
  phone: _mockPhone,
  company: 'Antfost Pvt. Ltd.',
  isKycVerified: true,
);

/// Mock remote data source for development / testing purposes.
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<UserModel> signIn({
    required String contact,
    required String passcode,
    required bool isEmail,
  }) async {
    await _fakeDelay();

    // Accept all credentials for testing

    return _dummyUser;
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String phone,
    required String company,
    required String passcode,
  }) async {
    await _fakeDelay();
    // Return a new user built from the submitted registration data.
    return UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      company: company,
      isKycVerified: false,
    );
  }

  @override
  Future<bool> verifyOtp({
    required String contact,
    required String otp,
    required bool isEmail,
  }) async {
    await _fakeDelay();
    return true;
  }

  @override
  Future<bool> forgotPasscode({
    required String contact,
    required bool isEmail,
  }) async {
    await _fakeDelay();
    return true;
  }

  @override
  Future<bool> resetPasscode({
    required String contact,
    required String otp,
    required String newPasscode,
  }) async {
    await _fakeDelay();
    return true;
  }

  @override
  Future<bool> signOut() async {
    await _fakeDelay();
    return true;
  }
}
