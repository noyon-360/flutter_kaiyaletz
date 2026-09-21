import 'package:flutter/material.dart';
import 'package:flutter_kaiyaletz/core/common/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/gap.dart';
import '../controller/support_controller.dart';

class ContactUsScreen extends ConsumerStatefulWidget {
  const ContactUsScreen({super.key});

  @override
  ConsumerState<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends ConsumerState<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final contactNumberController = TextEditingController();
  final noteController = TextEditingController();

  final emailFocus = FocusNode();
  final contactNumberFocus = FocusNode();
  final noteFocus = FocusNode();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    contactNumberController.dispose();
    noteController.dispose();
    emailFocus.dispose();
    contactNumberFocus.dispose();
    noteFocus.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await ref
        .read(supportProvider.notifier)
        .submitContactUs(
          fullName: fullNameController.text.trim(),
          email: emailController.text.trim(),
          contactNumber: contactNumberController.text.trim(),
          note: noteController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: const AppHeader(title: 'Contact Us'),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Full Name', style: AppTextStyles.inputLabel),
              Gap.h(8),
              AppTextField(
                hint: 'Enter your full name',
                controller: fullNameController,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => emailFocus.requestFocus(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),

              Gap.h(16),

              Text('Email', style: AppTextStyles.inputLabel),
              Gap.h(8),
              AppTextField(
                hint: 'Enter your email',
                controller: emailController,
                focusNode: emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => contactNumberFocus.requestFocus(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                  ).hasMatch(value.trim())) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              Gap.h(16),

              Text('Contact Number', style: AppTextStyles.inputLabel),
              Gap.h(8),
              AppTextField(
                hint: 'Enter your contact number',
                controller: contactNumberController,
                focusNode: contactNumberFocus,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => noteFocus.requestFocus(),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your contact number';
                  }
                  return null;
                },
              ),

              Gap.h(16),

              Text('Note', style: AppTextStyles.inputLabel),
              Gap.h(8),
              AppTextField(
                hint: 'Describe what you need',
                controller: noteController,
                focusNode: noteFocus,
                textInputAction: TextInputAction.done,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please describe what you need';
                  }
                  return null;
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Consumer(
                  builder: (context, ref, _) {
                    final error = ref.watch(
                      supportProvider.select((s) => s.submitContactUsError),
                    );

                    if (error.isEmpty) return const SizedBox.shrink();

                    return Text(
                      error,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.error),
                    );
                  },
                ),
              ),

              Gap.h(8),

              AppPrimaryButton(label: 'Submit', onAsyncPressed: submit),

              Gap.h(16),
            ],
          ),
        ),
      ),
    );
  }
}
