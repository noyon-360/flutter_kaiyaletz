import 'dart:async';

import 'package:flutter_kaiyaletz/features/job/models/job_create_response_model.dart';
import 'package:flutter_kaiyaletz/features/job/repos/job_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final jobProvider = NotifierProvider.autoDispose<JobController, JobState>(
  JobController.new,
);

class JobState {
  final List<JobModel>? job;
  final bool? isLoading;
  final bool isLoadingMore;
  final String search;
  final String? status;
  final int page;
  final int? totalPages;

  JobState({
    this.job,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.search = '',
    this.status,
    this.page = 1,
    this.totalPages,
  });

  bool get hasMore => totalPages == null || page < totalPages!;

  JobState copyWith({
    List<JobModel>? job,
    bool? isLoading,
    bool? isLoadingMore,
    String? search,
    String? status,
    bool clearStatus = false,
    int? page,
    int? totalPages,
  }) {
    return JobState(
      job: job ?? this.job,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
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

    final result = await repo.getJobs(
      search: state.search,
      status: state.status,
      page: 1,
    );

    result.fold(
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
  }

  /// Fetches the next page and appends it, for infinite scroll.
  Future<void> loadMore() async {
    if (state.isLoadingMore || state.isLoading == true || !state.hasMore) {
      return;
    }

    final repo = ref.read(jobRepo);
    final nextPage = state.page + 1;

    state = state.copyWith(isLoadingMore: true);

    final result = await repo.getJobs(
      search: state.search,
      status: state.status,
      page: nextPage,
    );

    result.fold(
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
}
