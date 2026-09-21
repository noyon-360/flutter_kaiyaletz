import 'package:flutter/material.dart';
import 'package:flutter_kaiyaletz/core/common/widgets/widgets.dart';

import '../../../core/common/widgets/app_scaffold.dart';
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
    );
  }
}
