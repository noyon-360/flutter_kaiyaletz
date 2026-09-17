import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    state = state.copyWith(isLoading: true, loginErrMsg: "");

    debugPrint(email);
    debugPrint("is remember: ${state.rememberMe}");

    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false, loginErrMsg: "Invalid Ok");
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
