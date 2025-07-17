// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BatchImpl _$$BatchImplFromJson(Map<String, dynamic> json) => _$BatchImpl(
      skuId: json['sku_id'] as String?,
      uomId: json['uom_id'] as String?,
      quantity: (json['quantity'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$$BatchImplToJson(_$BatchImpl instance) =>
    <String, dynamic>{
      'sku_id': instance.skuId,
      'uom_id': instance.uomId,
      'quantity': instance.quantity,
    };
