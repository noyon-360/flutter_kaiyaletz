import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authCtrlProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthState {
  final bool isLoading;
  final bool rememberMe;
  final String errMsg;

  AuthState({
    this.isLoading = false,
    this.rememberMe = false,
    this.errMsg = '',
  });

  AuthState copyWith({bool? isLoading, bool? rememberMe, String? errMsg}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      rememberMe: rememberMe ?? this.rememberMe,
      errMsg: errMsg ?? this.errMsg,
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
    state = state.copyWith(isLoading: true, errMsg: "");

    debugPrint(email);
    debugPrint("is remember: ${state.rememberMe}");

    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false, errMsg: "Invalid Ok");
  }

  /// [Funtion] Signup with email, pass, confirm pass
  Future<void> signup(String email, String pass, String confirmPass) async {
    state = state.copyWith(isLoading: true, errMsg: "");

    debugPrint(email);

    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false);
  }

  /// [State]
  Future<void> rememberMe(bool value) async {
    state = state.copyWith(rememberMe: value);
  }
}
