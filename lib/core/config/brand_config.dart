import 'package:flutter/foundation.dart';

@immutable
abstract interface class BrandConfig {
  String get appName;

  String get loadAssets;
}
