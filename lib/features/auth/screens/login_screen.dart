import 'package:flutter/material.dart';

import '../../../core/common/widgets/app_buttons.dart';
import '../../../core/common/widgets/app_logo.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/app_text_field.dart';
import '../../../core/constants/assets_const.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/gap.dart';
import '../widgets/remember_forgot_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  // Example async handler: simulates a network call so you can see the
  // button's spinner + disabled state. Swap this for the real login call
  // later (e.g. authController.login(email, password)).
  Future<void> _handleLogin() async {
    await Future.delayed(const Duration(seconds: 6));

    // Uncomment to test the error path — AppPrimaryButton doesn't catch
    // this, it just resets isLoading and rethrows, so it lands here:
    // throw Exception('Invalid credentials');

    debugPrint('Login successful');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLogo(images: AppAssets.img.logo, h: 90, fit: BoxFit.cover),

              Gap.h(20),

              /// [Text] widget for the welcome message.
              Text('Welcome Back', style: AppTextStyles.h1),
              Gap.h(8),

              /// [Text] widget for the welcome message.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Please enter your email & password to access your account.',
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

              AppTextField(
                hint: 'Enter your email ',

                onChanged: (value) {
                  debugPrint('Email changed: $value');
                },
              ),

              Gap.h(12),

              /// [Text] widget for the password label.
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Password', style: AppTextStyles.inputLabel),
              ),
              Gap.h(8),

              AppTextField(
                hint: 'Enter your password',
                isPassword: true,
                onChanged: (value) {
                  debugPrint('Password changed: $value');
                },
              ),

              Gap.h(12),

              /// [RememberForgotRow] widget for the "Remember Me" checkbox and "Forgot Password?" link.
              RememberForgotRow(
                rememberMe: _rememberMe,
                onRememberChanged: (value) {
                  setState(() => _rememberMe = value);
                },
                onForgotTap: () {
                  debugPrint('Forgot Password tapped');
                },
              ),

              Gap.h(24),

              /// [AppPrimaryButton] widget for the login action.
              AppPrimaryButton(
                onAsyncPressed: () => _handleLogin(),
                label: 'Login',
              ),

              Gap.h(16),

              /// [Row] widget for the "Don't have an account? Sign Up" link.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Gap.w(8),
                  GestureDetector(
                    onTap: () {
                      debugPrint('Sign Up tapped');
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
