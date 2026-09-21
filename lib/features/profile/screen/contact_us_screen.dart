import 'package:flutter/material.dart';
import 'package:flutter_kaiyaletz/core/common/widgets/widgets.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: const AppHeader(title: 'Contact Us'),
      body: Center(child: Text("Contact US")),
    );
  }
}
