import 'package:flutter/widgets.dart';
import 'package:flutter_kaiyaletz/core/common/widgets/widgets.dart';
import 'package:flutter_kaiyaletz/core/utils/d_print.dart';
import 'package:flutter_kaiyaletz/features/job/controller/job_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'job_steps_screen.dart';

class JobPogressScreen extends ConsumerWidget {
  const JobPogressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DPrint.log("JobPogressScreen");

    final currentStep = ref.watch(
      jobProvider.select((s) => s.currentStep ?? 1),
    );
    final jobStepTitle = ref.watch(jobProvider.select((s) => s.jobStepTitle));
    final hasNext = currentStep < jobStepNames.length;

    return AppScaffold(
      header: AppHeader(title: jobStepTitle),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StepProgressBar(
              currentStep: currentStep,
              onStepTap: (step) =>
                  ref.read(jobProvider.notifier).goToStep(step),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: KeyedSubtree(
                key: ValueKey(currentStep),
                child: jobStepWidgets[currentStep - 1],
              ),
            ),
          ],
        ),
      ),
      bottomBar: BottomActionBar(
        label: hasNext
            ? "Continue to ${jobStepNames[currentStep]}"
            : "Download PDF",
        onSimplePressed: hasNext
            ? () {
                ref.read(jobProvider.notifier).nextStep();
              }
            : null,
      ),
    );
  }
}
