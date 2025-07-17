import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:warehouse/core/freezed/result.dart';
import 'package:warehouse/core/network/network_bound_item.dart';
import 'package:warehouse/core/network/retrofit/api_client.dart';
import 'package:warehouse/core/network/retrofit/rest_api_executor.dart';
import 'package:warehouse/core/shared/app_error.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_response_dto.dart';
import 'package:warehouse/domain/repositories/picklist_repository.dart';


@Injectable(as: PicklistRepository)
class PicklistRepositoryImpl extends PicklistRepository{
  ApiClient _apiClient;

  PicklistRepositoryImpl(this._apiClient);
  
  @override
  Future fetchPickList(String token, String status) {
    return networkInBoundItem(
      apiRequest: () => RestApiExecutor.executeGeneric<PicklistResponseDto>(
        requestCall: () async {
          var restClient = await _apiClient.getRestClient();
          return restClient.getPicklist('Bearer $token', status);
        }),
      saveToDb: (_) => {},
      getSuccessState: (PicklistResponseDto dto) =>
          Result.success(dto.picklists.rows.map((e) => e.map()).toList()),
      getErrorState: (AppError errorApiResult) =>
          Result.failure(errorApiResult),
    );
  }
}