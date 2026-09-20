import 'package:flutter/material.dart';
import 'package:flutter_kaiyaletz/core/utils/d_print.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/models/session_status.dart';
import '../../../core/providers/core_provider.dart';
import '../../../core/utils/navigation.dart';
import '../../nav/screen/bottom_nav_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  late final Future<(SessionStatus, String)> _sessionStatusFuture;

  @override
  void initState() {
    super.initState();
    _sessionStatusFuture =
        Future.wait([
          ref.read(authStorageServiceProvider).currentSessionStatus(),
          ref.read(authStorageServiceProvider).getFirstName(),
          Future.delayed(const Duration(milliseconds: 600)), // floor duration
        ]).then(
          (results) =>
              (results[0] as SessionStatus, (results[1] as String?) ?? ''),
        );
    ApiClient.onSessionExpired = () => AppNav.offAll(const LoginScreen());
    ApiClient.onAuthRequired = () {};
  }

  @override
  Widget build(BuildContext context) {
    DPrint.log("Auth Gate");
    return FutureBuilder<(SessionStatus, String)>(
      future: _sessionStatusFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final (status, firstName) = snapshot.data ?? (SessionStatus.guest, '');

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (status == SessionStatus.authenticated) {
            if (firstName.isEmpty) {
              AppNav.offAll(const ProfileScreen());
            } else {
              AppNav.offAll(const BottomNavScreen());
            }
          } else {
            AppNav.offAll(const LoginScreen());
          }
        });

        return const Scaffold(
          body: SizedBox.shrink(),
        ); // brief placeholder while navigating away
      },
    );
  }
}
