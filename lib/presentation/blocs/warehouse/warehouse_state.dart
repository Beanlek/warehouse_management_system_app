import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/domain/entities/sites/site.dart';
import 'package:warehouse/domain/entities/warehouse_inventory/warehouse_inventory.dart';

part 'warehouse_state.freezed.dart';

@freezed
class WarehouseState with _$WarehouseState {
  const WarehouseState._();
  
  const factory WarehouseState({
    @Default(false) bool isLoading,
    @Default(null) String? siteId,
    @Default([]) List<Site> siteList,
    @Default(null) String? selectedBrand,
    @Default([]) List<String> brands,
    @Default('') String active,
    @Default([]) List<WarehouseInventory> warehouseInventoryList,
    @Default({}) Map<String, List<WarehouseInventory>> brandInventoryMap,
  }) = _WarehouseState;

}