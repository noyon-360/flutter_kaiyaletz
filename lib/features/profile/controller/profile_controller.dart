import 'package:flutter_kaiyaletz/features/profile/model/profile_model.dart';
import 'package:flutter_kaiyaletz/features/profile/repos/user_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider = NotifierProvider.autoDispose<ProfileCtrl, ProfileState>(
  ProfileCtrl.new,
);

class ProfileState {
  final ProfileModel? user;
  ProfileState({this.user});

  ProfileState copyWith({ProfileModel? user}) {
    return ProfileState(user: user ?? this.user);
  }
}

class ProfileCtrl extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    Future.microtask(getUser);
    return ProfileState();
  }

  Future<void> getUser({bool forceRefresh = false}) async {
    final repo = ref.read(userRepoProvider);

    repo.getProfile(forceRefresh: forceRefresh).listen((either) {
      either.fold((f) {}, (s) {
        state = state.copyWith(user: s.data);
      });
    });
  }
}
