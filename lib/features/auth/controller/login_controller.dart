import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState {
  final bool isLoading;


  LoginState({required this.isLoading,});
}

class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() {
    return LoginState(isLoading: false);
  }

  Future<void> login(String username, String password) async {
    // Simulate a login process
    await Future.delayed(const Duration(seconds: 2));

    // For demonstration purposes, we assume the login is always successful
    state = LoginState(isLoading: false);
  }
}
