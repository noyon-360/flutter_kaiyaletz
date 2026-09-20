import 'package:flutter/material.dart';
import 'package:flutter_kaiyaletz/core/common/widgets/widgets.dart';
import 'package:flutter_kaiyaletz/core/constants/assets_const.dart';
import 'package:flutter_kaiyaletz/core/theme/app_colors.dart';
import 'package:flutter_kaiyaletz/features/auth/controller/auth_controller.dart';
import 'package:flutter_kaiyaletz/features/setting/controller/setting_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/gap.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(settingsProfileProvider);

    return AppScaffold(
      padding: EdgeInsets.symmetric(horizontal: 0),
      header: const AppBackHeader(title: 'Settings'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            profileAsync.when(
              data: (profile) => SettingsProfileCard(
                name: profile.name,
                email: profile.email,
                avatar: profile.avatarUrl.isNotEmpty
                    ? NetworkImage(profile.avatarUrl)
                    : null,
              ),
              loading: () => const SettingsProfileCard(name: '', email: ''),
              error: (_, _) => const SettingsProfileCard(name: '', email: ''),
            ),
            Gap.h(20),
            SettingsGroup(
              children: [
                SettingsTile(
                  icon: AppAssets.icons.edit,
                  label: 'Edit Profile',
                  onTap: () {},
                ),
                SettingsTile(
                  icon: AppAssets.icons.general,
                  label: 'General Settings',
                  onTap: () {},
                ),
                SettingsTile(
                  icon: AppAssets.icons.notification,
                  label: 'Notification',
                  onTap: () {},
                ),
                SettingsTile(
                  icon: AppAssets.icons.email,
                  label: 'Contact Us',
                  onTap: () {},
                ),
              ],
            ),
            Gap.h(20),
            AppOutlineButton(
              onSimplePressed: () =>
                  ref.read(authCtrlProvider.notifier).logout(),
              label: 'Logout',
              color: AppColors.danger,
            ),
          ],
        ),
      ),
    );
  }
}
