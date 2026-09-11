class InputValidators {
  const InputValidators._();

  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required.';
    return null;
  }

  static String? fullName(String? value, {String fieldName = 'Full name'}) {
    final requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;
    if (value!.trim().length < 2) return 'Enter a valid $fieldName.';
    return null;
  }

  static String? username(String? value, {String fieldName = 'Username'}) {
    final requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;
    if (!RegExp(r'^[a-zA-Z0-9._-]{3,30}$').hasMatch(value!.trim())) {
      return '$fieldName must be 3–30 letters, numbers, dots, hyphens, or underscores.';
    }
    return null;
  }

  /// Development validation accepts supported mobile formats until backend
  /// validation is available.
  static String? mobile(String? value, {String fieldName = 'Mobile number'}) {
    final requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;
    final digits = value!.replaceAll(RegExp(r'[^0-9]'), '');
    final isUae = RegExp(r'^(?:9715\d{8}|05\d{8}|5\d{8})$').hasMatch(digits);
    final isIndia = RegExp(r'^(?:91)?[6-9]\d{9}$').hasMatch(digits);
    return isUae || isIndia ? null : 'Enter a valid phone number.';
  }

  static String? email(String? value, {String fieldName = 'Email address'}) {
    final requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value!.trim())
        ? null
        : 'Enter a valid email address.';
  }

  static String? phone(String? value, {String fieldName = 'Phone number'}) {
    final requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;
    final digits = value!.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.length >= 7 && digits.length <= 15
        ? null
        : 'Enter a valid phone number.';
  }

  static String? tradeRegistration(String? value, String fieldName) {
    final requiredError = required(value, fieldName);
    if (requiredError != null) return requiredError;
    return value!.trim().length >= 4 ? null : 'Enter a valid $fieldName.';
  }

  static String? trn(String? value) {
    final requiredError = required(value, 'Tax registration number');
    if (requiredError != null) return requiredError;
    return RegExp(r'^\d{15}$').hasMatch(value!.trim())
        ? null
        : 'TRN must contain 15 digits.';
  }

  static String? website(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    return uri != null && uri.hasScheme && uri.host.isNotEmpty
        ? null
        : 'Enter a valid website URL.';
  }

  static String? password(String? value) {
    final requiredError = required(value, 'Password');
    if (requiredError != null) return requiredError;
    if (value!.length < 8) return 'Password must be at least 8 characters.';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Confirm your password.';
    // Wait until the user has entered a complete password before showing a
    // mismatch error; this avoids flashing an error on the first character.
    if (value.length < 8) return null;
    return password == value ? null : 'Passwords do not match.';
  }

  static String? loginIdentifier(String? value, {required bool isBusiness}) {
    if (isBusiness) return username(value, fieldName: 'Business username');
    final requiredError = required(value, 'Mobile number or username');
    if (requiredError != null) return requiredError;
    final mobileError = mobile(value);
    return mobileError == null ? null : username(value);
  }
}
