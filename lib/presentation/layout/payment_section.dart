import 'package:flutter/widgets.dart';
import '../../domain/models/layout_block.dart';

/// Contract every integrable block conforms to. [type] matches the server id;
/// [build] returns a real widget for the given [block] (which carries its own
/// payload). Adding a widget = a new implementation + one registry entry.
abstract interface class PaymentSection {
  String get type;

  Widget build(BuildContext context, LayoutBlock block);
}
