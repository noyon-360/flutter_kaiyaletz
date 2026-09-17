import 'package:flutter/material.dart';
import 'package:flutter_kaiyaletz/features/auth/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/navigation.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SnapNDesign',
      theme: AppTheme.light,
      navigatorKey: AppNav.key,
      home: LoginScreen(),
    );
  }
}
