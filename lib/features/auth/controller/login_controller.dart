import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginCtrlProvider = NotifierProvider<LoginController, LoginState>(
  LoginController.new,
);

class LoginState {
  final bool isLoading;
  final bool rememberMe;

  LoginState({this.isLoading = false, this.rememberMe = false});

  LoginState copyWith({bool? isLoading, bool? rememberMe}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() {
    return LoginState();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    debugPrint(email);
    debugPrint("is remember: ${state.rememberMe}");

    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false);
  }

  Future<void> rememberMe(bool value) async {
    state = state.copyWith(rememberMe: value);
  }
}
