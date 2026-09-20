import 'package:flutter/material.dart';
import 'package:flutter_kaiyaletz/features/auth/controller/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/widgets/app_buttons.dart';
import '../../../core/common/widgets/app_logo.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/app_text_field.dart';
import '../../../core/constants/assets_const.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/gap.dart';
import '../../../core/utils/navigation.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // focus
  final passFocusNode = FocusNode();
  final confirmPassFocusNode = FocusNode();

  final localError = ValueNotifier<String?>(null);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    passFocusNode.dispose();
    confirmPassFocusNode.dispose();
    localError.dispose();
    super.dispose();
  }

  bool validate() {
    final pass = passwordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (pass != confirmPass) {
      localError.value = 'Passwords do not match';
      return false;
    }

    localError.value = null;
    return true;
  }

  Future<void> signup() {
    final email = emailController.text;
    final pass = passwordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    return ref.read(authCtrlProvider.notifier).signup(email, pass, confirmPass);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building SignupScreen");

    return AppScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLogo(images: AppAssets.img.logo, h: 90, fit: BoxFit.cover),

              Gap.h(20),

              /// [Text] widget for the welcome message.
              Text('Create Account', style: AppTextStyles.h1),
              Gap.h(8),

              /// [Text] widget for the welcome message.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Please enter your information and create your account.',
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),

              Gap.h(24),

              /// [Text] widget for the email label.
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Email', style: AppTextStyles.inputLabel),
              ),
              Gap.h(8),

              Consumer(
                builder: (context, ref, child) {
                  final isLoading = ref.watch(
                    authCtrlProvider.select((s) => s.isLoading),
                  );
                  return AppTextField(
                    hint: 'Enter your email',
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    enabled: !isLoading,
                  );
                },
              ),

              Gap.h(12),

              /// [Text] widget for the password label.
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Password', style: AppTextStyles.inputLabel),
              ),
              Gap.h(8),

              Consumer(
                builder: (context, ref, child) {
                  final isLoading = ref.watch(
                    authCtrlProvider.select((s) => s.isLoading),
                  );
                  return AppTextField(
                    hint: 'Enter your password',
                    controller: passwordController,
                    focusNode: passFocusNode,
                    textInputAction: TextInputAction.next,
                    isPassword: true,
                    enabled: !isLoading,
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
                    hint: 'Enter your confirm password',
                    controller: confirmPasswordController,
                    focusNode: confirmPassFocusNode,
                    textInputAction: TextInputAction.done,
                    isPassword: true,
                    enabled: !isLoading,
                  );
                },
              ),

              Gap.h(24),

              /// [localError]
              ValueListenableBuilder<String?>(
                valueListenable: localError,
                builder: (context, error, child) {
                  if (error == null) return const SizedBox.shrink();
                  return Column(
                    children: [
                      Text(error, style: TextStyle(color: AppColors.error)),
                      Gap.h(8),
                    ],
                  );
                },
              ),

              /// [errMsg]
              Consumer(
                builder: (context, ref, child) {
                  final errMsg = ref.watch(
                    authCtrlProvider.select((s) => s.signupErrMsg),
                  );

                  // if (errMsg.isEmpty) {
                  //   return const SizedBox.shrink();
                  // }
                  return Column(
                    children: [
                      Text(errMsg, style: TextStyle(color: AppColors.error)),
                      Gap.h(8),
                    ],
                  );
                },
              ),

              /// [AppPrimaryButton] widget for the signup action.
              AppPrimaryButton(
                label: 'Create Account',
                onValidate: validate,
                onAsyncPressed: signup,
              ),

              Gap.h(16),

              /// [Row] widget for the "Already have an account? Sign Up" link.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Gap.w(8),
                  GestureDetector(
                    onTap: () {
                      AppNav.back();
                    },
                    child: Text(
                      'Sign Up',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
