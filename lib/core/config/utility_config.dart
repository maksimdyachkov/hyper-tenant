import 'brand_config.dart';

class UtilityConfig implements BrandConfig {
  const UtilityConfig();

  @override
  String get appName => 'Utility Pay';

  @override
  String get loadAssets => 'assets/layouts/utility.json';
}
