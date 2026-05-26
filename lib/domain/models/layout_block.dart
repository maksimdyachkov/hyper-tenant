import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'layout_block.g.dart';

@JsonSerializable()
class LayoutBlock extends Equatable {
  const LayoutBlock({
    required this.type,
    this.data = const {},
  });

  final String type;
  final Map<String, dynamic> data;

  factory LayoutBlock.fromJson(Map<String, dynamic> json) =>
      _$LayoutBlockFromJson(json);

  Map<String, dynamic> toJson() => _$LayoutBlockToJson(this);

  @override
  List<Object?> get props => [type, data];
}

@JsonSerializable()
class PromoBannerData extends Equatable {
  const PromoBannerData({required this.text});

  final String text;

  factory PromoBannerData.fromJson(Map<String, dynamic> json) =>
      _$PromoBannerDataFromJson(json);

  Map<String, dynamic> toJson() => _$PromoBannerDataToJson(this);

  @override
  List<Object?> get props => [text];
}

@JsonSerializable()
class BillBreakdownData extends Equatable {
  const BillBreakdownData({required this.items});

  final List<BillLineItemDto> items;

  factory BillBreakdownData.fromJson(Map<String, dynamic> json) =>
      _$BillBreakdownDataFromJson(json);

  Map<String, dynamic> toJson() => _$BillBreakdownDataToJson(this);

  @override
  List<Object?> get props => [items];
}

@JsonSerializable()
class BillLineItemDto extends Equatable {
  const BillLineItemDto({required this.label, required this.amount});

  final String label;
  final double amount;

  factory BillLineItemDto.fromJson(Map<String, dynamic> json) =>
      _$BillLineItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BillLineItemDtoToJson(this);

  @override
  List<Object?> get props => [label, amount];
}
