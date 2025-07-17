// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BatchDtoImpl _$$BatchDtoImplFromJson(Map<String, dynamic> json) =>
    _$BatchDtoImpl(
      skuId: json['sku_id'] as String?,
      uomId: json['uom_id'] as String?,
      quantity: (json['quantity'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$$BatchDtoImplToJson(_$BatchDtoImpl instance) =>
    <String, dynamic>{
      'sku_id': instance.skuId,
      'uom_id': instance.uomId,
      'quantity': instance.quantity,
    };
