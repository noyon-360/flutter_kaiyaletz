import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// "Remember Me" checkbox + "Forgot Password?" link row.
///
/// Figma: checkbox 20×20, radius 4, border 1px #000000 (checked: fill
/// #C29266); "Remember Me" DM Sans Regular 14 #000000; "Forgot Password?"
/// DM Sans Regular 14 #C29266, right-aligned.
/// Used on: Login Screen.
class RememberForgotRow extends StatelessWidget {
  const RememberForgotRow({
    super.key,
    required this.rememberMe,
    required this.onRememberChanged,
    required this.onForgotTap,
  });

  final bool rememberMe;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onForgotTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onRememberChanged(!rememberMe),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: rememberMe,
                  onChanged: (v) => onRememberChanged(v ?? false),
                  activeColor: AppColors.primary,
                  checkColor: AppColors.onPrimary,
                  side: const BorderSide(color: AppColors.textPrimary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Remember Me',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onForgotTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'Forgot Password?',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
