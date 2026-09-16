import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/api_client.dart';
import '../../domain/entities/auth_flow.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSession> signIn({
    required String usernameOrMobile,
    required String password,
  });
  Future<OtpChallenge> signUpBusiness({
    required String companyName,
    required String username,
    required String registeredMobile,
    required String email,
    required String password,
  });
  Future<OtpChallenge> signUpIndividual({
    required String fullName,
    required String mobile,
    required String username,
    required String password,
    required bool termsAccepted,
  });
  Future<AuthSession> verifySignUpOtp({
    required String verificationId,
    required String otp,
  });
  Future<OtpChallenge> resendSignUpOtp({required String verificationId});
  Future<OtpChallenge> forgotPasscode({
    required String contact,
    required bool isEmail,
  });
  Future<PasswordResetVerification> verifyPasscodeOtp({
    required String verificationId,
    required String contact,
    required String otp,
  });
  Future<void> resetPasscode({
    required String resetToken,
    required String newPasscode,
  });
  Future<void> signOut({required String refreshToken});
}

/// Real Mobile API implementation. Paths are relative to `/api/mobile/v1`.
class ApiAuthRemoteDataSource implements AuthRemoteDataSource {
  ApiAuthRemoteDataSource(this._client);
  final ApiClient _client;

  @override
  Future<AuthSession> signIn({
    required String usernameOrMobile,
    required String password,
  }) => _request(() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/sign-in',
      data: {'usernameOrMobile': usernameOrMobile, 'password': password},
    );
    return _session(_data(response));
  });

  @override
  Future<OtpChallenge> signUpBusiness({
    required String companyName,
    required String username,
    required String registeredMobile,
    required String email,
    required String password,
  }) => _request(() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/sign-up/business',
      data: {
        'companyName': companyName,
        'username': username,
        'registeredMobile': registeredMobile,
        'channel': 'sms',
        'email_id': email,
        'password': password,
      },
    );
    return _challenge(_data(response), contactRequired: true);
  });

  @override
  Future<OtpChallenge> signUpIndividual({
    required String fullName,
    required String mobile,
    required String username,
    required String password,
    required bool termsAccepted,
  }) => _request(() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/sign-up/individual',
      data: {
        'fullName': fullName,
        'mobile': mobile,
        'username': username,
        'password': password,
        'termsAccepted': termsAccepted,
      },
    );
    return _challenge(_data(response), contactRequired: true);
  });

  @override
  Future<AuthSession> verifySignUpOtp({
    required String verificationId,
    required String otp,
  }) => _request(() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/sign-up/verify-otp',
      data: {'verificationId': verificationId, 'otp': otp},
    );
    return _session(_data(response), includeNextStep: true);
  });

  @override
  Future<OtpChallenge> resendSignUpOtp({required String verificationId}) =>
      _request(() async {
        final response = await _client.post<Map<String, dynamic>>(
          '/auth/sign-up/resend-otp',
          data: {'verificationId': verificationId},
        );
        return _challenge(_data(response));
      });

  @override
  Future<OtpChallenge> forgotPasscode({
    required String contact,
    required bool isEmail,
  }) => _request(() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/passcode/forgot',
      data: {'contact': contact, 'isEmail': isEmail},
    );
    return _challenge(_data(response), fallbackContact: contact);
  });

  @override
  Future<PasswordResetVerification> verifyPasscodeOtp({
    required String verificationId,
    required String contact,
    required String otp,
  }) => _request(() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/passcode/verify-otp',
      data: {'verificationId': verificationId, 'contact': contact, 'otp': otp},
    );
    final data = _data(response);
    if (data['verified'] != true || data['resetToken'] is! String)
      throw const ServerException('OTP verification response is invalid.');
    return PasswordResetVerification(resetToken: data['resetToken'] as String);
  });

  @override
  Future<void> resetPasscode({
    required String resetToken,
    required String newPasscode,
  }) => _request(() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/passcode/reset',
      data: {'resetToken': resetToken, 'newPasscode': newPasscode},
    );
    if (_data(response)['success'] != true)
      throw const ServerException('Passcode could not be reset.');
  });

  @override
  Future<void> signOut({required String refreshToken}) => _request(() async {
    final response = await _client.post<Map<String, dynamic>>(
      '/auth/sign-out',
      data: {'refreshToken': refreshToken},
    );
    if (_data(response)['success'] != true)
      throw const ServerException('Could not sign out.');
  });

  Future<T> _request<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (error) {
      final responseData = error.response?.data;
      final message = responseData is Map && responseData['message'] is String
          ? responseData['message'] as String
          : error.message ?? 'Unable to reach the server.';
      final fields = responseData is Map && responseData['fields'] is Map
          ? Map<String, String>.fromEntries(
              (responseData['fields'] as Map).entries
                  .where((entry) => entry.key is String)
                  .map(
                    (entry) =>
                        MapEntry(entry.key as String, entry.value.toString()),
                  ),
            )
          : const <String, String>{};
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          throw TimeoutException(message);
        case DioExceptionType.connectionError:
          throw NetworkException(message);
        default:
          if (error.response?.statusCode == 422) {
            throw ValidationException(message, fields);
          }
          if (error.response?.statusCode == 401 ||
              error.response?.statusCode == 403)
            throw AuthException(message);
          throw ServerException(message);
      }
    }
  }

  Map<String, dynamic> _data(Response<Map<String, dynamic>> response) {
    final data = response.data;
    if (data == null) throw const ServerException('Empty server response.');
    return data;
  }

  OtpChallenge _challenge(
    Map<String, dynamic> data, {
    String? fallbackContact,
    bool contactRequired = false,
  }) {
    final verificationId = data['verificationId'];
    final maskedContact = data['maskedContact'];
    final expiresAt = DateTime.tryParse(data['expiresAt'] as String? ?? '');
    final contact =
        data['contact'] as String? ?? fallbackContact ?? maskedContact;
    if (verificationId is! String ||
        maskedContact is! String ||
        expiresAt == null ||
        (contactRequired && data['contact'] is! String))
      throw const ServerException('OTP response is invalid.');
    return OtpChallenge(
      verificationId: verificationId,
      contact: contact,
      maskedContact: maskedContact,
      expiresAt: expiresAt,
      resendAvailableAt: DateTime.tryParse(
        data['resendAvailableAt'] as String? ?? '',
      ),
    );
  }

  AuthSession _session(
    Map<String, dynamic> data, {
    bool includeNextStep = false,
  }) {
    final user = data['user'];
    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];
    if (user is! Map<String, dynamic> ||
        accessToken is! String ||
        refreshToken is! String)
      throw const ServerException('Authentication response is invalid.');
    final nextStep = data['nextStep'] == 'kyc'
        ? AuthNextStep.kyc
        : data['nextStep'] == 'home'
        ? AuthNextStep.home
        : data['nextStep'] == 'verify_otp'
        ? AuthNextStep.verifyOtp
        : null;
    if (includeNextStep && nextStep == null)
      throw const ServerException('Authentication next step is invalid.');
    // Sign-in v1.1 puts the KYC and capability flags beside `user`, while
    // verification responses may put the same data on `user`. Merge them so
    // the cached session always describes the server's actual permissions.
    final sessionUser = Map<String, dynamic>.from(user);
    for (final key in ['kyc', 'accountState', 'access']) {
      if (!sessionUser.containsKey(key) && data.containsKey(key)) {
        sessionUser[key] = data[key];
      }
    }
    return AuthSession(
      user: UserModel.fromJson(sessionUser),
      accessToken: accessToken,
      refreshToken: refreshToken,
      nextStep: nextStep,
    );
  }
}
