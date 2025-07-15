// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_list_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryListResponseDtoImpl _$$InventoryListResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$InventoryListResponseDtoImpl(
      inventory: (json['inventory'] as List<dynamic>)
          .map((e) => WarehouseInventoryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$InventoryListResponseDtoImplToJson(
        _$InventoryListResponseDtoImpl instance) =>
    <String, dynamic>{
      'inventory': instance.inventory,
    };
