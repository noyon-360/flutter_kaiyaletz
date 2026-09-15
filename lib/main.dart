import 'package:flutter/material.dart';
import 'package:flutter_kaiyaletz/features/auth/screens/login_screen.dart';

import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SnapNDesign',
      theme: AppTheme.light,
      home: LoginScreen(),
    );
  }
}
