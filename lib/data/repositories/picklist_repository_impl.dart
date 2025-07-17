import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:warehouse/core/freezed/result.dart';
import 'package:warehouse/core/network/network_bound_item.dart';
import 'package:warehouse/core/network/retrofit/api_client.dart';
import 'package:warehouse/core/network/retrofit/rest_api_executor.dart';
import 'package:warehouse/core/shared/app_error.dart';
import 'package:warehouse/data/models/batch/batch_dto.dart';
import 'package:warehouse/data/models/packing/packing_dto.dart';
import 'package:warehouse/data/models/picklist/picklist_details_dto.dart';
import 'package:warehouse/data/models/picklist/picklist_dto.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_details_response_dto.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_response_dto.dart';
import 'package:warehouse/domain/entities/batch/batch.dart';
import 'package:warehouse/domain/entities/packing/packing.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';
import 'package:warehouse/domain/entities/picklist/picklist_details.dart';
import 'package:warehouse/domain/repositories/picklist_repository.dart';


@Injectable(as: PicklistRepository)
class PicklistRepositoryImpl extends PicklistRepository{
  final ApiClient _apiClient;

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

  @override
  Future fetchPickListDetails(String token, String picklistId) {
    return networkInBoundItem(
      apiRequest: () => RestApiExecutor.executeGeneric<PicklistDetailsResponseDto>(
        requestCall: () async {
          var restClient = await _apiClient.getRestClient();
          return restClient.getPicklistDetails('Bearer $token', picklistId);
        }),
      saveToDb: (_) => {},
      getSuccessState: (PicklistDetailsResponseDto dto) {
        
          final List<PicklistDto> picklistList = [dto.picklist];
          
          return Result.success(PicklistDetails(
            picklist: picklistList.map((e) => e.map()).whereType<Picklist>().toList()[0],
            batch: dto.batch.map((e) => e.map()).whereType<Batch>().toList(),
            packing: dto.packing.map((e) => e.map()).whereType<Packing>().toList()
          ));
        },
      getErrorState: (AppError errorApiResult) =>
          Result.failure(errorApiResult),
    );
  }
}