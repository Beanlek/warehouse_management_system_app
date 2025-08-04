import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:warehouse/core/freezed/result.dart';
import 'package:warehouse/core/network/network_bound_item.dart';
import 'package:warehouse/core/network/retrofit/api_client.dart';
import 'package:warehouse/core/network/retrofit/rest_api_executor.dart';
import 'package:warehouse/core/shared/app_error.dart';
import 'package:warehouse/data/models/responses/sites/site_list_response_dto.dart';
import 'package:warehouse/data/models/responses/warehouse/inventory_list_response_dto.dart';
import 'package:warehouse/domain/entities/sites/site.dart';
import 'package:warehouse/domain/entities/warehouse_inventory/warehouse_inventory.dart';
import 'package:warehouse/domain/repositories/warehouse_inventory_repository.dart';

@Injectable(as: WarehouseInventoryRepository)
class WarehouseInventoryRepositoryImpl extends WarehouseInventoryRepository{
  ApiClient _apiClient;

  WarehouseInventoryRepositoryImpl(this._apiClient);
  
  @override
  Future<Result<List<WarehouseInventory>, AppError>> fetchWarehouseInventory(String token, String siteId, String active) async {
    debugPrint('Fetching warehouse inventory for site: $siteId with token: $token');
    return networkInBoundItem(
      apiRequest: () => RestApiExecutor.executeGeneric<InventoryListResponseDto>(
        requestCall: () async {
          var restClient = await _apiClient.getRestClient();
          return restClient.getWarehouseInventory('Bearer $token', siteId, active);
        }),
      saveToDb: (InventoryListResponseDto _) => {},
      getSuccessState: (InventoryListResponseDto dto) =>
          Result.success(dto.inventory.map((e) => e.map()).toList()),
      getErrorState: (AppError errorApiResult) =>
          Result.failure(errorApiResult),
    );
  }
  
  @override
  Future <Result<List<Site>, AppError>> fetchSiteList(String token) async {
    debugPrint('(repo) Fetching sites with token: $token');
    return networkInBoundItem(
      apiRequest: () => RestApiExecutor.executeGeneric<SiteListResponseDto>(
        requestCall: () async {
          var restClient = await _apiClient.getRestClient();
          return restClient.getSiteList('Bearer $token');
        }),
      saveToDb: (SiteListResponseDto _) => {},
      getSuccessState: (SiteListResponseDto dto) =>
          Result.success(dto.sites.map((e) => e.map()).toList()),
      getErrorState: (AppError errorApiResult) =>
          Result.failure(errorApiResult),
    );
  }
}