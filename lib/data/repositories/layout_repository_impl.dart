import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../../domain/models/layout_block.dart';
import '../../domain/repositories/layout_repository.dart';

/// Loads the SDUI layout from a bundled JSON asset and parses it via
/// LayoutBlock.fromJson (same path a real network response would take).
class LayoutRepositoryImpl implements LayoutRepository {
  LayoutRepositoryImpl(this.assetPath);

  final String assetPath;

  @override
  Future<List<LayoutBlock>> getPaymentScreenLayout() async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => LayoutBlock.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
