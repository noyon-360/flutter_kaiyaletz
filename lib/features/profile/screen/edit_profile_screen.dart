import 'package:flutter/material.dart';
import 'package:flutter_kaiyaletz/core/common/widgets/app_scaffold.dart';

import '../../../core/common/widgets/app_back_header.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: const AppHeader(title: 'Edit Profile'),
      body: Center(child: Text("Edit Profile")),
    );
  }
}
