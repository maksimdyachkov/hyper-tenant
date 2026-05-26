// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LayoutBlock _$LayoutBlockFromJson(Map<String, dynamic> json) => LayoutBlock(
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$LayoutBlockToJson(LayoutBlock instance) =>
    <String, dynamic>{
      'type': instance.type,
      'data': instance.data,
    };

PromoBannerData _$PromoBannerDataFromJson(Map<String, dynamic> json) =>
    PromoBannerData(
      text: json['text'] as String,
    );

Map<String, dynamic> _$PromoBannerDataToJson(PromoBannerData instance) =>
    <String, dynamic>{
      'text': instance.text,
    };

BillBreakdownData _$BillBreakdownDataFromJson(Map<String, dynamic> json) =>
    BillBreakdownData(
      items: (json['items'] as List<dynamic>)
          .map((e) => BillLineItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BillBreakdownDataToJson(BillBreakdownData instance) =>
    <String, dynamic>{
      'items': instance.items,
    };

BillLineItemDto _$BillLineItemDtoFromJson(Map<String, dynamic> json) =>
    BillLineItemDto(
      label: json['label'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$BillLineItemDtoToJson(BillLineItemDto instance) =>
    <String, dynamic>{
      'label': instance.label,
      'amount': instance.amount,
    };
