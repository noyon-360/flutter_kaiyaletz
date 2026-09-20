import 'package:flutter/widgets.dart';
import 'package:flutter_kaiyaletz/core/services/auth_storage_service.dart';
import 'package:flutter_kaiyaletz/features/auth/repo/auth_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_provider.dart';

final authCtrlProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthState {
  final bool isLoading;
  final bool rememberMe;
  final String loginErrMsg;
  final String signupErrMsg;

  AuthState({
    this.isLoading = false,
    this.rememberMe = false,
    this.loginErrMsg = '',
    this.signupErrMsg = '',
  });

  AuthState copyWith({
    bool? isLoading,
    bool? rememberMe,
    String? loginErrMsg,
    String? signupErrMsg,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      rememberMe: rememberMe ?? this.rememberMe,
      loginErrMsg: loginErrMsg ?? this.loginErrMsg,
      signupErrMsg: signupErrMsg ?? this.signupErrMsg,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState();
  }

  

  /// [Funtion] login with email and pass
  Future<void> login(String email, String password) async {
    final repo = ref.read(authRepoProvider);

    state = state.copyWith(isLoading: true, loginErrMsg: "");

    final result = await repo.login(email: email, password: password);

    await result.fold(
      (f) async {
        state = state.copyWith(isLoading: false, loginErrMsg: f.message);
      },
      (s) async {
        final data = s.data;

        final account = StoredAccount(
          userId: data.id,
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
          role: data.role,
          firstName: data.firstName,
          lastName: data.lastName,
          profileImage: data.profileImage.url,
          email: data.email,
        );

        await ref.read(authStorageServiceProvider).storeAuthData(account);
        if (state.rememberMe) {
          await ref.read(authStorageServiceProvider).saveAccountToList(account);
        }
        state = state.copyWith(isLoading: false, loginErrMsg: '');
      },
    );
  }

  /// [Funtion] Signup with email, pass, confirm pass
  Future<void> signup(String email, String pass, String confirmPass) async {
    state = state.copyWith(isLoading: true, loginErrMsg: "");

    debugPrint(email);

    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false);
  }

  /// [State]
  Future<void> rememberMe(bool value) async {
    state = state.copyWith(rememberMe: value);
  }
}
