import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/domain/entities/sites/site.dart';
import 'package:warehouse/domain/entities/warehouse_inventory/warehouse_inventory.dart';


part 'warehouse_event.freezed.dart';

@freezed
class WarehouseEvent with _$WarehouseEvent {
  const factory WarehouseEvent.setup() = Setup;
  const factory WarehouseEvent.selectSite(String siteId) = SelectSite;
  const factory WarehouseEvent.selectBrand(String? brand) = SelectBrand;
  const factory WarehouseEvent.setupSiteList(List<Site> siteList) = SetupSiteList;
  const factory WarehouseEvent.loadBrandList(List<String> brands) = LoadBrandList;
  const factory WarehouseEvent.loadWarehouseInventory(List<WarehouseInventory> warehouseInventoryList) = LoadWarehouseInventory;
  const factory WarehouseEvent.loadBrandInventoryList(Map<String, List<WarehouseInventory>> brandInventoryMap) = LoadBrandInventoryList;
}
