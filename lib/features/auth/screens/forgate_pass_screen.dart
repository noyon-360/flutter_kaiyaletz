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
import '../../../core/utils/navigation.dart';
import '../controller/auth_controller.dart';

class ForgatePassScreen extends ConsumerStatefulWidget {
  const ForgatePassScreen({super.key});

  @override
  ConsumerState<ForgatePassScreen> createState() => _ForgatePassScreenState();
}

class _ForgatePassScreenState extends ConsumerState<ForgatePassScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<void> sendResetCode() {
    final email = emailController.text.trim();

    return ref.read(authCtrlProvider.notifier).forgotPass(email: email);
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
                Text('Forgot Password', style: AppTextStyles.h1),
                Gap.h(8),

                /// [Text] widget for the helper message.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "Enter your email and we'll send you a code to reset your password",
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
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      enabled: !isLoading,
                      validator: validateEmail,
                    );
                  },
                ),

                Gap.h(24),

                /// [errMsg]
                Consumer(
                  builder: (context, ref, child) {
                    final errMsg = ref.watch(
                      authCtrlProvider.select((s) => s.forgotPassError),
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

                /// [AppPrimaryButton] widget for sending the reset code.
                AppPrimaryButton(
                  label: 'Sign In',
                  onValidate: () => formKey.currentState!.validate(),
                  onAsyncPressed: sendResetCode,
                ),

                Gap.h(16),

                /// [Row] widget for the "Remember Password? Sign In" link.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember Password?',
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
                        'Sign In',
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
      ),
    );
  }
}
