import 'package:flutter/widgets.dart';
import 'package:flutter_kaiyaletz/core/common/widgets/app_header.dart';
import 'package:flutter_kaiyaletz/core/common/widgets/app_scaffold.dart';
import 'package:flutter_kaiyaletz/features/job/controller/job_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobPogress extends StatelessWidget {
  const JobPogress({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: Consumer(
        builder: (context, ref, _) {
          final jobStepNames = ref.watch(
            jobProvider.select((s) => s.jobStepNames),
          );
          return AppHeader(title: jobStepNames);
        },
      ),
      body: Center(child: Text("Job Progress")),
    );
  }
}
