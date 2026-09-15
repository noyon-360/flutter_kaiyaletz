import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Job statuses shown in the design.
enum JobStatus { newJob, inProgress, proposalSent, completed }

extension JobStatusX on JobStatus {
  String get label => switch (this) {
    JobStatus.newJob => 'New',
    JobStatus.inProgress => 'In Progress',
    JobStatus.proposalSent => 'Proposal Sent',
    JobStatus.completed => 'Completed',
  };

  Color get color => switch (this) {
    JobStatus.newJob => AppColors.statusNew,
    JobStatus.inProgress => AppColors.statusInProgress,
    JobStatus.proposalSent => AppColors.statusProposalSent,
    JobStatus.completed => AppColors.statusCompleted,
  };
}

/// Colored status label.
///
/// Figma: padding 6/2, background = status color at 20%,
/// text DM Sans Regular 10 in the status color.
/// Used on: Home (Recent Jobs), All Jobs, Catalog Add.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required JobStatus this.status, this.radius = 0})
    : _label = null,
      _color = null;

  /// For any other label/color (e.g. the "AI" badge on Room Capture).
  const StatusChip.custom({
    super.key,
    required String label,
    required Color color,
    this.radius = 0,
  }) : status = null,
       _label = label,
       _color = color;

  final JobStatus? status;
  final String? _label;
  final Color? _color;

  /// The design has square corners. Increase for a pill look.
  final double radius;

  @override
  Widget build(BuildContext context) {
    final color = status?.color ?? _color!;
    final label = status?.label ?? _label!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(51),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(label, style: AppTextStyles.caption.copyWith(color: color)),
    );
  }
}
