import 'package:flutter/material.dart';
import 'package:flutter_kaiyaletz/core/common/widgets/app_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(body: Center(child: Text('Home Screen')));
  }
}
