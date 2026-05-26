import 'package:equatable/equatable.dart';
import '../../core/error/failure.dart';
import '../../domain/models/layout_block.dart';
import '../../domain/models/payment_summary.dart';

enum ContentStatus { initial, loading, success, failure }

class PaymentContentState extends Equatable {
  final ContentStatus status;
  final PaymentSummary? summary;
  final List<LayoutBlock> layout;
  final PaymentFailure? failure;

  const PaymentContentState({
    this.status = ContentStatus.initial,
    this.summary,
    this.layout = const [],
    this.failure,
  });

  PaymentContentState copyWith({
    ContentStatus? status,
    PaymentSummary? summary,
    List<LayoutBlock>? layout,
    PaymentFailure? failure,
  }) {
    return PaymentContentState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      layout: layout ?? this.layout,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, summary, layout, failure];
}
