/// Endpoint paths. Replace `baseDomain` with your real API base URL and
/// add sections the same way `auth` is structured, one class per resource.
class ApiConstants {
  ApiConstants._();

  // static const String baseDomain = 'http://10.10.26.115:5001'; // [Office]
  static const String baseDomain = 'http://localhost:5001'; // [Home]

  static const String baseUrl = '$baseDomain/api/v1';

  /// Dynamically generated WebSocket URL based on baseDomain
  static String get webSocketUrl {
    if (baseDomain.startsWith('https://')) {
      return baseDomain.replaceFirst('https://', 'wss://');
    } else if (baseDomain.startsWith('http://')) {
      return baseDomain.replaceFirst('http://', 'ws://');
    }
    // Fallback for unexpected cases (e.g., no scheme)
    return 'ws://$baseDomain';
  }

  /// [Headers]
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  static Map<String, String> get multipartHeaders => {
    'Accept': 'application/json',
    // Content-Type will be set automatically for multipart
  };

  static const AuthEndpoints auth = AuthEndpoints();
  static const UserEndpoints user = UserEndpoints();
  static const SupportEndpoints support = SupportEndpoints();
}

class AuthEndpoints {
  const AuthEndpoints();

  static const String _base = '/auth/';

  String get login => '${_base}login';
  String get register => '${_base}register';
  String get resendOtp => '${_base}resend-otp';
  String get verifyEmail => '/auth/verify-email';
  String get forgotPassword => '${_base}forgot-password';

  // Not Tested this api
  String get refreshToken => '/auth/refresh-token';

  String get verifyResetOtp => '/auth/verify-reset-otp';
  String get resetPassword => '/auth/reset-password';
}

class UserEndpoints {
  const UserEndpoints();

  static const String _base = '/user/';

  String get profile => '${_base}profile';
  String get changePass => '${_base}change-password';
  String get notification => '${_base}notifications';
}

class SupportEndpoints {
  const SupportEndpoints();

  static const String _base = '/support/';

  String get contactUs => _base;
}
