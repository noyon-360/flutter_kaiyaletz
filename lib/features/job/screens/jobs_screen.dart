import 'package:flutter/material.dart';
import 'package:flutter_kaiyaletz/core/common/widgets/widgets.dart';
import 'package:flutter_kaiyaletz/core/utils/gap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/job_controller.dart';

const _statusFilters = <String, JobStatus?>{
  'All': null,
  'New': JobStatus.newJob,
  'In Progress': JobStatus.inProgress,
  'Proposal Sent': JobStatus.proposalSent,
  'Completed': JobStatus.completed,
};

class JobsScreen extends ConsumerStatefulWidget {
  const JobsScreen({super.key});

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedStatus = ref.watch(jobProvider.select((s) => s.status));
    final selectedIndex = _statusFilters.values.toList().indexWhere(
      (status) => status?.apiValue == selectedStatus,
    );

    return AppScaffold(
      padding: EdgeInsets.symmetric(horizontal: 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSearchField(
            hint: 'Search jobs, customers...',
            controller: _searchController,
            onChanged: (value) =>
                ref.read(jobProvider.notifier).setSearch(value),
          ),
          const Gap(h: 12),
          FilterChipRow(
            options: _statusFilters.keys.toList(),
            selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
            onSelected: (index) {
              final status = _statusFilters.values.elementAt(index);
              ref.read(jobProvider.notifier).setStatus(status?.apiValue);
            },
          ),
          const Gap(h: 12),
          const Expanded(child: JobListView(paginate: true)),
        ],
      ),
    );
  }
}
