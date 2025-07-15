import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_inventory.freezed.dart';

@freezed
class WarehouseInventory with _$WarehouseInventory {
  const WarehouseInventory._();

  const factory WarehouseInventory({
    String? brand,
    String? category,
    @JsonKey(name: 'sub_category') String? subCategory,
    @JsonKey(name: 'sku_id') String? skuId,
    @JsonKey(name: 'sku_name') String? skuName,
    int? sequence,
    @JsonKey(name: 'uom_id') String? uomId,
    @JsonKey(name: 'short_code') String? shortCode,
    String? name,
    List<int?>? quantity,
    @JsonKey(name: 'available_sku_conversion') List<String?>? availableSkuConversion,
  }) = _WarehouseInventory;
}
