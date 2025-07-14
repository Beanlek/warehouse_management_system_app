import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:warehouse/core/freezed/result.dart';
import 'package:warehouse/core/network/network_bound_item.dart';
import 'package:warehouse/core/network/retrofit/api_client.dart';
import 'package:warehouse/core/network/retrofit/rest_api_executor.dart';
import 'package:warehouse/core/shared/app_error.dart';
import 'package:warehouse/core/utils/iterable_extensions.dart';
import 'package:warehouse/data/models/responses/site_list_response_dto.dart';
import 'package:warehouse/data/models/sites/site_dto.dart';
import 'package:warehouse/data/models/warehouse/warehouse_inventory_dto.dart';
import 'package:warehouse/domain/entities/sites/site.dart';
import 'package:warehouse/domain/repositories/warehouse_inventory_repository.dart';

@Injectable(as: WarehouseInventoryRepository)
class WarehouseInventoryRepositoryImpl extends WarehouseInventoryRepository{
  ApiClient _apiClient;

  WarehouseInventoryRepositoryImpl(this._apiClient);
  
  @override
  Future fetchWarehouseInventory(String token, String siteId) {
    debugPrint('Fetching warehouse inventory for site: $siteId with token: $token');
    return networkInBoundItem(
      apiRequest: () => RestApiExecutor.executeForList<WarehouseInventoryDto>(
        requestCall: () async {
          var restClient = await _apiClient.getRestClient();
          return restClient.getWarehouseInventory(
            token,
            siteId,
          );
        }),
      saveToDb: (List<WarehouseInventoryDto> responseList) => {},
      getSuccessState: (List<WarehouseInventoryDto> apiResult) =>
          Result.success(apiResult.mapNotNull((item) => item.map()).toList()),
      getErrorState: (AppError errorApiResult) =>
          Result.failure(errorApiResult),
    );
  }
  
  @override
  Future <Result<List<Site>, AppError>> fetchSiteList(String token) {
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