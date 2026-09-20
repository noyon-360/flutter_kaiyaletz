import 'package:flutter/material.dart';

import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/utils/d_print.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DPrint.log("Home Screen");

    return AppScaffold(body: Center(child: Text("Home Screen")));
  }
}
