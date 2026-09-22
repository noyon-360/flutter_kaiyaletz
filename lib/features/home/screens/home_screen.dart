import 'package:flutter/material.dart';
import 'package:flutter_kaiyaletz/core/common/widgets/widgets.dart';
import 'package:flutter_kaiyaletz/core/constants/assets_const.dart' hide Icons;
import 'package:flutter_kaiyaletz/core/theme/app_colors.dart';
import 'package:flutter_kaiyaletz/core/theme/app_text_styles.dart';
import 'package:flutter_kaiyaletz/core/utils/app_svg.dart';
import 'package:flutter_kaiyaletz/core/utils/navigation.dart';
import 'package:flutter_kaiyaletz/features/job/screens/create_job_screen.dart';
import 'package:flutter_kaiyaletz/features/profile/controller/profile_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/d_print.dart';
import '../../../core/utils/greeting.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DPrint.log("Home Screen");

    return AppScaffold(
      padding: EdgeInsets.symmetric(horizontal: 0),
      header: Consumer(
        builder: (context, ref, _) {
          final profile = ref.watch(profileProvider.select((s) => s.user));

          String greeting = greetingForNow();

          return AppHeader.custom(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.surfaceTag,
              backgroundImage:
                  profile != null && profile.profileImage.url.isNotEmpty
                  ? NetworkImage(profile.profileImage.url)
                  : null,
              child: profile == null || profile.profileImage.url.isEmpty
                  ? const Icon(Icons.person_outline, color: AppColors.textDark)
                  : null,
            ),

            middle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting, style: AppTextStyles.overline),
                Text(
                  profile?.firstName ?? "",
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.textWarmDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            trailing: InkResponse(
              onTap: () {},
              radius: 20,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.surfaceTag,
                child: AppSvg(
                  asset: AppAssets.icons.notification,
                  width: 20,
                  height: 20,
                  color: AppColors.textDark,
                ),
              ),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Consumer(
            //   builder: (context, ref, _) {
            //     final user = ref.watch(
            //       profileProvider.select((state) => state.user),
            //     );
            //     return Row(children: [Text(user!.fullName)]);
            //   },
            // ),
            Center(child: Text("Home Screen")),
          ],
        ),
      ),
      floatingActionButton: AppFab(
        onSimplePressed: () => AppNav.to(CreateJobScreen()),
      ),
    );
  }
}
