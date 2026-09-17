/// Endpoint paths. Replace `baseDomain` with your real API base URL and
/// add sections the same way `auth` is structured, one class per resource.
class ApiConstants {
  ApiConstants._();

  static const String baseDomain = 'http://10.10.26.115:5001'; // [Office]

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
  // static const JobsEndpoints jobs = JobsEndpoints();
}

class AuthEndpoints {
  const AuthEndpoints();

  String get login => '/auth/login';
  String get register => '/auth/register';
  String get refreshToken => '/auth/refresh-token';
  String get forgotPassword => '/auth/forgot-password';
  String get verifyOtp => '/auth/verify-otp';
  String get resetPassword => '/auth/reset-password';
}

// Example of a resource with path-parameter endpoints — copy this shape
// for Jobs, Catalog, etc.
//
// class JobsEndpoints {
//   const JobsEndpoints();
//
//   String get list => '/jobs';
//   String get create => '/jobs';
//   String detail(String id) => '/jobs/$id';
//   String update(String id) => '/jobs/$id';
//   String delete(String id) => '/jobs/$id';
// }
