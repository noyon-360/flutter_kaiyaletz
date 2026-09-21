import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/common/models/network_result.dart';
import '../../../core/providers/core_provider.dart';

final userRepoProvider = Provider<UserRepo>((ref) {
  final apiClient = ref.watch(apiClientProvider);

  return UserRepoImpl(apiClient: apiClient);
});

abstract class UserRepo {
  NetworkResult<void> updateProfile({
    required String fullName,
    required String phoneNumber,
    required String address,
    File? profileImage,
  });
}

class UserRepoImpl implements UserRepo {
  final ApiClient apiClient;

  const UserRepoImpl({required this.apiClient});

  @override
  NetworkResult<void> updateProfile({
    required String fullName,
    required String phoneNumber,
    required String address,
    File? profileImage,
  }) async {
    final formData = FormData.fromMap({
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      if (profileImage != null)
        'profileImage': await MultipartFile.fromFile(
          profileImage.path,
          filename: profileImage.path.split('/').last,
        ),
    });

    return apiClient.patch<void>(
      endpoint: ApiConstants.user.updateProfile,
      formData: formData,
      fromJsonT: (json) => json,
    );
  }
}
