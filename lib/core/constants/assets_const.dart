class AppAssets {
  AppAssets._();
  static Images get img => Images();
  static Icons get icons => Icons();
}

class Images {
  const Images();

  static const String _base = 'assets/img/';
  final String logo = '$_base/app_logo.png';
}

class Icons {
  const Icons();

  static const String _base = 'assets/icons/';
  final String back = '${_base}back-icon.svg';
}
