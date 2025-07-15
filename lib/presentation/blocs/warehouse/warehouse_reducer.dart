
import 'package:warehouse/presentation/blocs/warehouse/warehouse_event.dart';
import 'package:warehouse/presentation/blocs/warehouse/warehouse_state.dart';

import '../base/reducer.dart';

class WarehouseReducer extends Reducer<WarehouseEvent, WarehouseState> {
  @override
  WarehouseState reduce(WarehouseEvent newEvent, WarehouseState currentState) {
    return currentState.copyWith(
      isLoading: newEvent.maybeWhen(
        selectSite: (_) => false,
        loadWarehouseInventory: (_) => false,
        orElse: () => currentState.isLoading,
      ),
      siteId: newEvent.maybeWhen(
        selectSite: (siteId) => siteId,
        orElse: () => currentState.siteId,
      ),
      brands: newEvent.maybeWhen(
        loadBrandList: (brands) => brands,
        orElse: () => currentState.brands,
      ),
      selectedBrand: newEvent.maybeWhen(
        selectBrand: (selectedBrand) => selectedBrand,
        selectSite: (_) => null,
        orElse: () => currentState.selectedBrand
      ),
      warehouseInventoryList: newEvent.maybeWhen(
        loadWarehouseInventory: (warehouseInventoryList) => warehouseInventoryList,
        orElse: () => currentState.warehouseInventoryList,
      ),
      siteList: newEvent.maybeWhen(
        setupSiteList: (siteList) => siteList,
        orElse: () => currentState.siteList,
      ),
    );
  }
}