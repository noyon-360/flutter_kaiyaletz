import 'package:flutter/material.dart';
import 'package:flutter_kaiyaletz/core/common/widgets/widgets.dart';
import 'package:flutter_kaiyaletz/core/utils/navigation.dart';
import 'package:flutter_kaiyaletz/features/job/screens/create_job_screen.dart';

import '../../../core/utils/d_print.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DPrint.log("Home Screen");

    return AppScaffold(
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
