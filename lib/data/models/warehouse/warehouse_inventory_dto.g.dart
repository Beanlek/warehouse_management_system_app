// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_inventory_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WarehouseInventoryDtoImpl _$$WarehouseInventoryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$WarehouseInventoryDtoImpl(
      brand: json['brand'] as String?,
      category: json['category'] as String?,
      subCategory: json['sub_category'] as String?,
      skuId: json['sku_id'] as String?,
      skuName: json['sku_name'] as String?,
      sequence: (json['sequence'] as num?)?.toInt(),
      uomId: json['uom_id'] as String?,
      shortCode: json['short_code'] as String?,
      name: json['name'] as String?,
      quantity: (json['quantity'] as List<dynamic>?)
          ?.map((e) => (e as num?)?.toInt())
          .toList(),
      availableSkuConversion:
          (json['available_sku_conversion'] as List<dynamic>?)
              ?.map((e) => e as String?)
              .toList(),
    );

Map<String, dynamic> _$$WarehouseInventoryDtoImplToJson(
        _$WarehouseInventoryDtoImpl instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'category': instance.category,
      'sub_category': instance.subCategory,
      'sku_id': instance.skuId,
      'sku_name': instance.skuName,
      'sequence': instance.sequence,
      'uom_id': instance.uomId,
      'short_code': instance.shortCode,
      'name': instance.name,
      'quantity': instance.quantity,
      'available_sku_conversion': instance.availableSkuConversion,
    };
