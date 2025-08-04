
import 'package:warehouse/presentation/blocs/warehouse/warehouse_event.dart';
import 'package:warehouse/presentation/blocs/warehouse/warehouse_state.dart';

import '../base/reducer.dart';

class WarehouseReducer extends Reducer<WarehouseEvent, WarehouseState> {
  @override
  WarehouseState reduce(WarehouseEvent newEvent, WarehouseState currentState) {
    return currentState.copyWith(
      isLoading: newEvent.maybeWhen(
        selectSite: (_) => true,
        selectActive: (active) => true,
        loadWarehouseInventory: (_) => false,
        loadBrandList: (_) => false,
        loadBrandInventoryList: (_) => false,
        orElse: () => currentState.isLoading,
      ),
      siteId: newEvent.maybeWhen(
        selectSite: (siteId) => siteId,
        orElse: () => currentState.siteId,
      ),
      brands: newEvent.maybeWhen(
        setup: () => [],
        loadBrandList: (brands) => brands,
        orElse: () => currentState.brands,
      ),
      selectedBrand: newEvent.maybeWhen(
        setup: () => null,
        selectBrand: (selectedBrand) => selectedBrand,
        selectSite: (_) => null,
        orElse: () => currentState.selectedBrand
      ),
      warehouseInventoryList: newEvent.maybeWhen(
        setup: () => [],
        loadWarehouseInventory: (warehouseInventoryList) => warehouseInventoryList,
        orElse: () => currentState.warehouseInventoryList,
      ),
      brandInventoryMap: newEvent.maybeWhen(
        setup: () => {},
        loadBrandInventoryList: (brandInventoryMap) => brandInventoryMap,
        orElse: () => currentState.brandInventoryMap,
      ),
      siteList: newEvent.maybeWhen(
        setupSiteList: (siteList) => siteList,
        orElse: () => currentState.siteList,
      ),
      active: newEvent.maybeWhen(
        selectActive: (active) => active,
        orElse: () => currentState.active
      ),
    );
  }
}