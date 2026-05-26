import '../models/layout_block.dart';

abstract interface class LayoutRepository {
  Future<List<LayoutBlock>> getPaymentScreenLayout();
}
