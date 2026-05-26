import 'brand_config.dart';

class RetailConfig implements BrandConfig {
  const RetailConfig();

  @override
  String get appName => 'Retail Shop';

  @override
  String get loadAssets => 'assets/layouts/retail.json';
}
