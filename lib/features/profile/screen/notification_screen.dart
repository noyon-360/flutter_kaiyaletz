import 'package:flutter/material.dart';
import 'package:flutter_kaiyaletz/core/common/widgets/widgets.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: const AppHeader(title: 'Notification'),
      body: Center(child: Text("Notification")),
    );
  }
}
