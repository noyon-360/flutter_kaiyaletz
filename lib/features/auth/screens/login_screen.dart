import 'package:flutter/material.dart';

import '../../../core/common/widgets/app_back_header.dart';
import '../../../core/common/widgets/app_bottom_nav_bar.dart';
import '../../../core/common/widgets/app_buttons.dart';
import '../../../core/common/widgets/app_logo.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/app_search_field.dart';
import '../../../core/common/widgets/app_text_field.dart';
import '../../../core/constants/assets_const.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/gap.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

              Text('Welcome Back', style: AppTextStyles.h1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Please enter your email & password to access your account.',
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),

              Gap.h(24),

              AppTextField(
                hint: 'Enter your email ',

                onChanged: (value) {
                  debugPrint('Email changed: $value');
                },
              ),

              const SizedBox(height: 16),

              AppTextField(
                hint: '********************',

                onChanged: (value) {
                  debugPrint('Password changed: $value');
                },
              ),

              const SizedBox(height: 16),
              AppPrimaryButton(
                onAsyncPressed: () => _handleLogin(),
                label: 'Login with API Call',
              ),
            ],
          ),
        ),
      ),

      // floatingActionButton : BottomActionBar(
      //   label: 'Login',
      //   onAsyncPressed: () => _handleLogin(),
      // ),
      bottomBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          debugPrint('Tapped bottom nav item $index');
        },
      ),
    );
  }
}
