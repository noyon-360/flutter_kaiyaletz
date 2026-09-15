class AppAssets {
  AppAssets._();
  static Images get img => Images();
}

class Images {
  const Images();

  static const String _base = 'assets/img/';
  final String logo = '$_base/app_logo.png';
}
