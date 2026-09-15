import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Screen header with back arrow and title.
///
/// Figma ("Navigation Stutus"): back icon 24 → 8px gap → title
/// Playfair Display SemiBold 20 #1E1E1E.
/// Used on 18 screens: All Jobs, Catalog, Catalog Details, Catalog Add,
/// Create Job, Job Details, Room Capture, Measurements,
/// Continue to Room Captured, Ai Layout, Estimate, Proposal, Edit Profile,
/// General Settings, Change Password, Notification settings,
/// Delete Account, Contact us.
///
/// Pass it to `AppScaffold(header: ...)`.
class AppBackHeader extends StatelessWidget {
  const AppBackHeader({
    super.key,
    required this.title,
    this.onBack,
    this.showBack = true,
    this.trailing,
  });

  final String title;

  /// Defaults to `Navigator.maybePop`.
  final VoidCallback? onBack;

  /// Set false on tab screens (e.g. Catalog opened from the bottom nav).
  final bool showBack;

  /// Optional widget on the right (e.g. an edit or share icon).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack) ...[
          InkResponse(
            onTap: onBack ?? () => Navigator.maybePop(context),
            radius: 20,
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.h2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ?trailing,
      ],
    );
  }
}
