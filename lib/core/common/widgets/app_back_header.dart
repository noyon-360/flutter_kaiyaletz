import 'package:flutter/material.dart';

import '../../constants/assets_const.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/app_svg.dart';

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
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.title,
    this.onBack,
    this.showBack,
    this.trailing,
  });

  final String title;

  /// Defaults to `Navigator.maybePop`.
  final VoidCallback? onBack;

  /// Whether to show the back arrow. Defaults to `null`, which shows it
  /// only when there's a previous route to pop back to (via
  /// `Navigator.canPop`) — e.g. hidden automatically on tab-root screens
  /// like Catalog opened from the bottom nav. Pass `true`/`false` to
  /// override the auto-detection.
  final bool? showBack;

  /// Optional widget on the right (e.g. an edit or share icon).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final canGoBack = showBack ?? Navigator.canPop(context);
    return Row(
      children: [
        if (canGoBack) ...[
          InkResponse(
            onTap: onBack ?? () => Navigator.maybePop(context),
            radius: 20,
            child: AppSvg(
              asset: AppAssets.icons.back,
              width: 24,
              height: 24,
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
