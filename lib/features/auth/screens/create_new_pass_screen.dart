import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/widgets/app_buttons.dart';
import '../../../core/common/widgets/app_logo.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/app_text_field.dart';
import '../../../core/constants/assets_const.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/gap.dart';
import '../controller/auth_controller.dart';

class CreateNewPassScreen extends ConsumerStatefulWidget {
  const CreateNewPassScreen({super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  ConsumerState<CreateNewPassScreen> createState() =>
      _CreateNewPassScreenState();
}

class _CreateNewPassScreenState extends ConsumerState<CreateNewPassScreen> {
  final formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // focus
  final confirmPassFocusNode = FocusNode();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    confirmPassFocusNode.dispose();
    super.dispose();
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a new password';
    }
    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }
    if (value.trim() != passwordController.text.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> resetPassword() {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    return ref
        .read(authCtrlProvider.notifier)
        .resetPass(widget.email, widget.otp, password, confirmPassword);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLogo(images: AppAssets.img.logo, h: 90, fit: BoxFit.cover),

                Gap.h(20),

                /// [Text] widget for the screen title.
                Text('Create New Password', style: AppTextStyles.h1),

                Gap.h(24),

                /// [Text] widget for the new password label.
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('New Password', style: AppTextStyles.inputLabel),
                ),
                Gap.h(8),

                Consumer(
                  builder: (context, ref, child) {
                    final isLoading = ref.watch(
                      authCtrlProvider.select((s) => s.isLoading),
                    );
                    return AppTextField(
                      hint: 'Enter your new password',
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      isPassword: true,
                      enabled: !isLoading,
                      validator: validatePassword,
                    );
                  },
                ),

                Gap.h(12),

                /// [Text] widget for the confirm password label.
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Confirm Password',
                    style: AppTextStyles.inputLabel,
                  ),
                ),
                Gap.h(8),

                Consumer(
                  builder: (context, ref, child) {
                    final isLoading = ref.watch(
                      authCtrlProvider.select((s) => s.isLoading),
                    );
                    return AppTextField(
                      hint: 'Confirm your new password',
                      controller: confirmPasswordController,
                      focusNode: confirmPassFocusNode,
                      textInputAction: TextInputAction.done,
                      isPassword: true,
                      enabled: !isLoading,
                      validator: validateConfirmPassword,
                    );
                  },
                ),

                Gap.h(24),

                /// [errMsg]
                Consumer(
                  builder: (context, ref, child) {
                    final errMsg = ref.watch(
                      authCtrlProvider.select((s) => s.resetPassError),
                    );

                    if (errMsg.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        Text(errMsg, style: TextStyle(color: AppColors.error)),
                        Gap.h(8),
                      ],
                    );
                  },
                ),

                /// [AppPrimaryButton] widget for the reset password action.
                AppPrimaryButton(
                  label: 'Sign In',
                  onValidate: () => formKey.currentState!.validate(),
                  onAsyncPressed: resetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
