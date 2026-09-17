import 'package:flutter_kaiyaletz/core/constants/api_constants.dart';
import 'package:flutter_kaiyaletz/core/providers/core_provider.dart';
import 'package:flutter_kaiyaletz/core/utils/d_print.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/models/network_result.dart';

final authRepoProvider = Provider<AuthRepo>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return AuthRepoImpl(apiClient: apiClient);
});

abstract class AuthRepo {
  NetworkResult<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  NetworkResult<void> forgotPassword({required String email});
}

class AuthRepoImpl implements AuthRepo {
  final ApiClient apiClient;

  const AuthRepoImpl({required this.apiClient});

  @override
  NetworkResult<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    DPrint.log("Login Working...");

    final data = apiClient.post<Map<String, dynamic>>(
      endpoint: ApiConstants.auth.login,
      data: {'email': email, 'password': password},
      fromJsonT: (json) => json as Map<String, dynamic>,
    );

    DPrint.log("Repo : ${data}");

    return data;
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
