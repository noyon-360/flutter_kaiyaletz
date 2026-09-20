import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/models/session_status.dart';
import '../../../core/providers/core_provider.dart';
import '../../../core/utils/navigation.dart';
import '../../nav/screen/bottom_nav_screen.dart';
import 'login_screen.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  @override
  void initState() {
    super.initState();
    ApiClient.onSessionExpired = () => AppNav.offAll(const LoginScreen());
    ApiClient.onAuthRequired = () {};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SessionStatus>(
      future: ref.read(authStorageServiceProvider).currentSessionStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final status = snapshot.data ?? SessionStatus.guest;
        return status == SessionStatus.authenticated
            ? const BottomNavScreen()
            : const LoginScreen();
      },
    );
  }
}
