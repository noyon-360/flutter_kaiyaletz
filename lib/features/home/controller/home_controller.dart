import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeCtrlProvider = NotifierProvider<HomeController, HomeState>(
  HomeController.new,
);

class HomeState {
  HomeState();
}

class HomeController extends Notifier<HomeState> {
  @override
  HomeState build() => HomeState();
}
