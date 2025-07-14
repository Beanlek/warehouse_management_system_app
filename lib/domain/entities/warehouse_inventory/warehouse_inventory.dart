import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_inventory.freezed.dart';

@freezed
class WarehouseInventory with _$WarehouseInventory {
  const WarehouseInventory._();

  const factory WarehouseInventory({
    required String brand,
    required String category,
    @JsonKey(name: 'sub_category') required String subCategory,
    @JsonKey(name: 'sku_id') required String skuId,
    @JsonKey(name: 'sku_name') required String skuName,
    required int sequence,
    @JsonKey(name: 'uom_id') required String uomId,
    @JsonKey(name: 'short_code') required String shortCode,
    required String name,
    required List<int> quantity,
    @JsonKey(name: 'available_sku_conversion') required List<String> availableSkuConversion,
  }) = _WarehouseInventory;
}
