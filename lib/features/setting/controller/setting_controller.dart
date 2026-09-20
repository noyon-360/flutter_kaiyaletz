import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_provider.dart';

/// Basic profile info shown at the top of the Settings screen.
class SettingsProfile {
  final String name;
  final String email;
  final String avatarUrl;

  const SettingsProfile({
    required this.name,
    required this.email,
    required this.avatarUrl,
  });
}

final settingsProfileProvider = FutureProvider.autoDispose<SettingsProfile>((
  ref,
) async {
  final storage = ref.watch(authStorageServiceProvider);

  final firstName = await storage.getFirstName() ?? '';
  final lastName = await storage.getLastName() ?? '';
  final email = await storage.getEmail() ?? '';
  final avatarUrl = await storage.getProfileImage() ?? '';

  final name = [
    firstName,
    lastName,
  ].where((part) => part.isNotEmpty).join(' ');

  return SettingsProfile(name: name, email: email, avatarUrl: avatarUrl);
});
