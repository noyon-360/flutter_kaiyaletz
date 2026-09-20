import 'package:flutter_kaiyaletz/core/constants/api_constants.dart';
import 'package:flutter_kaiyaletz/core/providers/core_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/models/network_result.dart';
import '../model/login_response_model.dart';

final authRepoProvider = Provider<AuthRepo>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return AuthRepoImpl(apiClient: apiClient);
});

abstract class AuthRepo {
  NetworkResult<UserData> login({
    required String email,
    required String password,
  });

  NetworkResult<void> forgotPassword({required String email});
}

class AuthRepoImpl implements AuthRepo {
  final ApiClient apiClient;

  const AuthRepoImpl({required this.apiClient});

  @override
  NetworkResult<UserData> login({
    required String email,
    required String password,
  }) {
    // ApiClient already parses the outer {success, message, data} envelope,
    // so this converter receives only the `data` object.
    return apiClient.post<UserData>(
      endpoint: ApiConstants.auth.login,
      data: {'email': email, 'password': password},
      fromJsonT: (json) => UserData.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  NetworkResult<void> forgotPassword({required String email}) {
    return apiClient.post<void>(
      endpoint: '/auth/forgot-password',
      data: {'email': email},
      fromJsonT: (_) {},
    );
  }
}
