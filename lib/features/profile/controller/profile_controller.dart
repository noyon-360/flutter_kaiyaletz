import 'package:flutter_kaiyaletz/core/utils/app_snackbar.dart';
import 'package:flutter_kaiyaletz/features/auth/controller/auth_controller.dart';
import 'package:flutter_kaiyaletz/features/profile/model/profile_model.dart';
import 'package:flutter_kaiyaletz/features/profile/repos/user_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/navigation.dart';

final profileProvider = NotifierProvider.autoDispose<ProfileCtrl, ProfileState>(
  ProfileCtrl.new,
);

class ProfileState {
  final ProfileModel? user;
  final int deleteAccountReasonIndex;
  final String deleteAccountOtherReason;
  final bool isLoadingDeleteAccoung;
  final String changePassErrorMsg;

  ProfileState({
    this.user,
    this.deleteAccountReasonIndex = 0,
    this.deleteAccountOtherReason = '',
    this.isLoadingDeleteAccoung = false,
    this.changePassErrorMsg = '',
  });

  ProfileState copyWith({
    ProfileModel? user,
    int? deleteAccountReasonIndex,
    String? deleteAccountOtherReason,
    bool? isLoadingDeleteAccoung,
    String? changePassErrorMsg,
  }) {
    return ProfileState(
      user: user ?? this.user,
      deleteAccountReasonIndex:
          deleteAccountReasonIndex ?? this.deleteAccountReasonIndex,
      deleteAccountOtherReason:
          deleteAccountOtherReason ?? this.deleteAccountOtherReason,
      isLoadingDeleteAccoung:
          isLoadingDeleteAccoung ?? this.isLoadingDeleteAccoung,
      changePassErrorMsg: changePassErrorMsg ?? this.changePassErrorMsg,
    );
  }
}

class ProfileCtrl extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    Future.microtask(getUser);
    return ProfileState();
  }

  /// [User] start
  ///
  Future<void> getUser({bool forceRefresh = false}) async {
    final repo = ref.read(userRepoProvider);

    repo.getProfile(forceRefresh: forceRefresh).listen((either) {
      either.fold((f) {}, (s) {
        state = state.copyWith(user: s.data);
      });
    });
  }

  Future<void> changePassword({
    required String currentPass,
    required String newPass,
    required String confirmPass,
  }) async {
    final repo = ref.read(userRepoProvider);

    final result = await repo.changePassword(
      currentPass: currentPass,
      newPass: newPass,
      confirmPass: confirmPass,
    );

    result.fold(
      (f) {
        state = state.copyWith(changePassErrorMsg: f.message);
      },
      (s) {
        AppSnackbar.success(s.message);
        AppNav.back();
      },
    );
  }

  /// [User] end

  /// [Delete Account] start
  ///
  void selectDeleteAccountReason(int index) {
    state = state.copyWith(deleteAccountReasonIndex: index);
  }

  void setDeleteAccountOtherReason(String value) {
    state = state.copyWith(deleteAccountOtherReason: value);
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isLoadingDeleteAccoung: true);

    await Future.delayed(const Duration(seconds: 10));

    await ref.read(authCtrlProvider.notifier).logout();
  }

  /// [Delete Account] End
}
