import 'package:flutter_kaiyaletz/core/api/api_client.dart';
import 'package:flutter_kaiyaletz/core/common/models/network_result.dart';
import 'package:flutter_kaiyaletz/core/constants/api_constants.dart';
import 'package:flutter_kaiyaletz/core/providers/core_provider.dart';
import 'package:flutter_kaiyaletz/features/job/models/job_create_response_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final jobRepo = Provider<JobRepo>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return JobRepoImpl(apiClient: apiClient);
});

abstract class JobRepo {
  NetworkResult<JobModel> createJob({
    required DateTime date,
    required String customerName,
    required String propertyAddress,
    required String phoneNumber,
    required String emailAddress,
    required String notes,
  });
}

class JobRepoImpl implements JobRepo {
  final ApiClient apiClient;
  JobRepoImpl({required this.apiClient});

  @override
  NetworkResult<JobModel> createJob({
    required DateTime date,
    required String customerName,
    required String propertyAddress,
    required String phoneNumber,
    required String emailAddress,
    required String notes,
  }) {
    return apiClient.post(
      endpoint: ApiConstants.job.createJob,
      data: {
        "date": date.toIso8601String(),
        "customerName": customerName,
        "propertyAddress": propertyAddress,
        "phoneNumber": phoneNumber,
        "emailAddress": emailAddress,
        "notes": notes,
      },
      fromJsonT: (json) => JobModel.fromJson(json),
    );
  }
}
