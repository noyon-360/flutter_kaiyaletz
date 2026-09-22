import 'package:flutter_kaiyaletz/core/api/api_client.dart';
import 'package:flutter_kaiyaletz/core/common/models/network_result.dart';
import 'package:flutter_kaiyaletz/core/constants/api_constants.dart';
import 'package:flutter_kaiyaletz/core/providers/core_provider.dart';
import 'package:flutter_kaiyaletz/features/job/models/dashboard_response_model.dart';
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

  NetworkStream<List<JobModel>> getJobs({
    String search = "",
    String? status,
    int page = 1,
    int limit = 20,
  });

  NetworkResult<DashboardResponseModel> dashboard();
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
      endpoint: ApiConstants.job.job,
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

  @override
  NetworkResult<DashboardResponseModel> dashboard() {
    return apiClient.get(
      endpoint: ApiConstants.job.dashboard,
      fromJsonT: (json) => DashboardResponseModel.fromJson(json),
    );
  }

  @override
  NetworkStream<List<JobModel>> getJobs({
    String search = "",
    String? status,
    int page = 1,
    int limit = 20,
  }) {
    return apiClient.getStream(
      endpoint: ApiConstants.job.job,
      queryParameters: {
        if (search.isNotEmpty) "search": search,
        if (status != null && status.isNotEmpty) "status": status,
        "page": page,
        "limit": limit,
      },
      fromJsonT: (json) =>
          (json as List).map((item) => JobModel.fromJson(item)).toList(),
    );
  }
}
