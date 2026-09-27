import 'dart:async';

import 'package:flutter_kaiyaletz/core/utils/navigation.dart';
import 'package:flutter_kaiyaletz/features/job/models/job_create_response_model.dart';
import 'package:flutter_kaiyaletz/features/job/repos/job_repo.dart';
import 'package:flutter_kaiyaletz/features/job/screens/job_pogress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/single_job_reponse_model.dart';

/// Names of the job workflow steps, in order, matching [JobModel.currentStep].
const List<String> jobStepNames = [
  "Job Details", // Step 1
  "Room Capture", // Step 2
  "Measurements", // Step 3
  "Select Product", // Step 4
  "AI Layout", // Step 5
  "Design", // Step 6
  "Estimate", // Step 7
  "Proposal", // Step 8
];

final jobProvider = NotifierProvider.autoDispose<JobController, JobState>(
  JobController.new,
);

class JobState {
  final List<JobModel>? job;
  final SingleJobResponseModel? singleJob;

  final bool? isLoading;
  final bool? isJobLoading;
  final bool isLoadingMore;

  final String jobStepNames;

  final String search;
  final String? status;
  final int page;
  final int? totalPages;

  JobState({
    this.job,
    this.singleJob,

    this.isLoading = false,
    this.isJobLoading = false,
    this.isLoadingMore = false,

    this.jobStepNames = '',

    this.search = '',
    this.status,
    this.page = 1,
    this.totalPages,
  });

  bool get hasMore => totalPages == null || page < totalPages!;

  JobState copyWith({
    List<JobModel>? job,
    SingleJobResponseModel? singleJob,

    bool? isLoading,
    bool? isJobLoading,
    bool? isLoadingMore,
    bool clearStatus = false,

    String? jobStepNames,

    String? search,
    String? status,
    int? page,
    int? totalPages,
  }) {
    return JobState(
      job: job ?? this.job,
      singleJob: singleJob ?? this.singleJob,
      isLoading: isLoading ?? this.isLoading,
      isJobLoading: isJobLoading ?? this.isJobLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      jobStepNames: jobStepNames ?? this.jobStepNames,
      search: search ?? this.search,
      status: clearStatus ? null : (status ?? this.status),
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class JobController extends Notifier<JobState> {
  Timer? _searchDebounce;

  @override
  JobState build() {
    ref.onDispose(() => _searchDebounce?.cancel());
    Future.microtask(getJobs);
    return JobState();
  }

  /// Fetches page 1 with the current search/status filters, replacing the list.
  Future<void> getJobs() async {
    final repo = ref.read(jobRepo);

    state = state.copyWith(isLoading: true, page: 1);

    repo.getJobs(search: state.search, status: state.status, page: 1).listen((
      either,
    ) {
      either.fold(
        (f) {
          state = state.copyWith(isLoading: false);
        },
        (s) {
          state = state.copyWith(
            job: s.data,
            isLoading: false,
            page: s.pagination?.page ?? 1,
            totalPages: s.pagination?.pages,
          );
        },
      );
    });
  }

  /// Fetches the next page and appends it, for infinite scroll.
  Future<void> loadMore() async {
    if (state.isLoadingMore || state.isLoading == true || !state.hasMore) {
      return;
    }

    final repo = ref.read(jobRepo);
    final nextPage = state.page + 1;

    state = state.copyWith(isLoadingMore: true);

    repo
        .getJobs(search: state.search, status: state.status, page: nextPage)
        .listen((either) {
          either.fold(
            (f) {
              state = state.copyWith(isLoadingMore: false);
            },
            (s) {
              state = state.copyWith(
                job: [...?state.job, ...s.data],
                isLoadingMore: false,
                page: s.pagination?.page ?? nextPage,
                totalPages: s.pagination?.pages,
              );
            },
          );
        });
  }

  /// Debounces user input before re-querying page 1.
  void setSearch(String value) {
    state = state.copyWith(search: value);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), getJobs);
  }

  /// Pass `null` to clear the status filter.
  void setStatus(String? status) {
    state = state.copyWith(status: status, clearStatus: status == null);
    getJobs();
  }

  void addJob(JobModel job) {
    state = state.copyWith(job: [job, ...?state.job]);
  }

  /// e.g. "Step 4: AI Layout" for currentStep == 4.
  String jobStepLabel(int currentStep) {
    final index = (currentStep - 1).clamp(0, jobStepNames.length - 1);
    return 'Step $currentStep: ${jobStepNames[index]}';
  }

  Future<void> jobStepTitle(int currentStep) async {
    final index = (currentStep - 1).clamp(0, jobStepNames.length - 1);
    state = state.copyWith(jobStepNames: jobStepNames[index]);
  }

  Future<void> getJobById(String jobId) async {
    final repo = ref.read(jobRepo);

    state = state.copyWith(isJobLoading: true);

    final result = await repo.getSingleJob(jobId: jobId);

    result.fold(
      (f) {
        state = state.copyWith(isJobLoading: false);
      },
      (s) async {
        state = state.copyWith(singleJob: s.data, isJobLoading: false);

        await jobStepTitle(s.data.currentStep);

        AppNav.to(JobPogress());
      },
    );
  }
}
