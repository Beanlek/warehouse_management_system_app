import 'package:flutter/foundation.dart';
import 'package:warehouse/domain/entities/warehouse_inventory/warehouse_inventory.dart';
import 'package:warehouse/domain/usecases/warehouse_inventory/fetch_sites_list_use_case.dart';
import 'package:warehouse/domain/usecases/warehouse_inventory/fetch_warehouse_inventory_list_use_case.dart';
import 'package:warehouse/injection.dart';
import 'package:warehouse/presentation/blocs/base/base_bloc.dart';
import 'package:warehouse/presentation/blocs/base/reducer.dart';
import 'package:warehouse/presentation/blocs/warehouse_inventory/warehouse_event.dart';
import 'package:warehouse/presentation/blocs/warehouse_inventory/warehouse_reducer.dart';
import 'package:warehouse/presentation/blocs/warehouse_inventory/warehouse_state.dart';

class WarehouseBloc extends BaseBloc<WarehouseEvent, WarehouseState> {
  List<WarehouseInventory> warehouseInventoryList = [];

  @override
  Reducer<WarehouseEvent, WarehouseState> reducer = WarehouseReducer();
  final FetchWarehouseInventoryListUseCase _fetchWarehouseInventoryListUseCase;
  final FetchSitesListUseCase _fetchSitesListUseCase;

  WarehouseBloc()
      :  _fetchWarehouseInventoryListUseCase = getIt<FetchWarehouseInventoryListUseCase>(),
        _fetchSitesListUseCase = getIt<FetchSitesListUseCase>(),
        super(const WarehouseState());

  @override
  void init() {
    process(Setup());
  }

  @override
  void processFeedback(WarehouseEvent event, WarehouseState state) async {
    event.maybeWhen(
        setup: () => _fetchSites(),
        selectSite: (siteId) => _processListsSetup(siteId),
        orElse: () {});
  }

  _fetchSites() async {
    await _fetchSitesListUseCase.execute().then((value) {
      value.maybeWhen(
          success: (result) {
            process(WarehouseEvent.setupSiteList(result));
            process(WarehouseEvent.selectSite(result.first.id));
          },
          orElse: () {});
    });
  }

  _processListsSetup(String siteId) async {
    debugPrint('WarehouseBloc: Processing lists setup for siteId: $siteId');
    // await _fetchWarehouseInventoryListUseCase.execute(siteId).then((value) {
    //   //populate the products list
    //   value.maybeWhen(
    //       success: (result) {
    //         warehouseInventoryList = result;
    //         process(WarehouseEvent.loadWarehouseInventory(warehouseInventoryList));
    //       },
    //       orElse: () {});
    // });
  }
}
