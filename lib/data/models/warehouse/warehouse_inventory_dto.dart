import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/core/network/interfaces/base_dto_model.dart';
import 'package:warehouse/domain/entities/warehouse_inventory/warehouse_inventory.dart';

part 'warehouse_inventory_dto.freezed.dart';
part 'warehouse_inventory_dto.g.dart';

@freezed
class WarehouseInventoryDto with _$WarehouseInventoryDto implements BaseDtoModel<WarehouseInventory> {
  const WarehouseInventoryDto._();

  const factory WarehouseInventoryDto({
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
  }) = _WarehouseInventoryDto;

  factory WarehouseInventoryDto.fromJson(Map<String, Object?> json) =>
      _$WarehouseInventoryDtoFromJson(json);

  @override
  List<Object?> get props => [
        brand,
        category,
        subCategory,
        skuId,
        skuName,
        sequence,
        uomId,
        shortCode,
        name,
        quantity,
        availableSkuConversion,
      ];

  @override
  WarehouseInventory map() {
    return WarehouseInventory(
      brand: brand,
      category: category,
      subCategory: subCategory,
      skuId: skuId,
      skuName: skuName,
      sequence: sequence,
      uomId: uomId,
      shortCode: shortCode,
      name: name,
      quantity: quantity,
      availableSkuConversion: availableSkuConversion,
    );
  }
}
