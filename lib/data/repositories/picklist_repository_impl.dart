import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:warehouse/core/freezed/network_error.dart';
import 'package:warehouse/core/freezed/result.dart';
import 'package:warehouse/core/network/network_bound_item.dart';
import 'package:warehouse/core/network/retrofit/api_client.dart';
import 'package:warehouse/core/network/retrofit/rest_api_executor.dart';
import 'package:warehouse/core/shared/app_error.dart';
import 'package:warehouse/data/models/picklist/picklist_dto.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_delete_response_dto.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_details_response_dto.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_pack_all_response_dto.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_response_dto.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_send_for_picking_response_dto.dart';
import 'package:warehouse/domain/entities/batch/batch.dart';
import 'package:warehouse/domain/entities/packing/packing.dart';
import 'package:warehouse/domain/entities/picklist/picklist.dart';
import 'package:warehouse/domain/entities/picklist/picklist_details.dart';
import 'package:warehouse/domain/repositories/picklist_repository.dart';


@Injectable(as: PicklistRepository, env: ['prod','dev'])
class PicklistRepositoryImpl extends PicklistRepository{
  final ApiClient _apiClient;

  PicklistRepositoryImpl(this._apiClient);
  
  @override
  Future fetchPickList(String token, String picklistId, String status, int page) async {
    return networkInBoundItem(
      apiRequest: () => RestApiExecutor.executeGeneric<PicklistResponseDto>(
        requestCall: () async {
          var restClient = await _apiClient.getRestClient();
          return restClient.getPicklist('Bearer $token', picklistId, status, page, 20);
        }),
      saveToDb: (_) => {},
      getSuccessState: (PicklistResponseDto dto) =>
          Result.success(dto.picklists.map()),
          //Result.success(dto.picklists.rows.map((e) => e.map()).toList()),
      getErrorState: (AppError errorApiResult) =>
          Result.failure(errorApiResult),
    );
  }


  @override
  Future fetchPickListDetails(String token, String picklistId) async {
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

  @override
  Future deletePickList(String token, Map<String, dynamic> picklistData) async {
    var restClient = await _apiClient.getRestClient();

    return await restClient.deletePicklist('Bearer $token', picklistData)
      .then((value) => Future<Result<PicklistDeleteResponseDto, NetworkError>>.value(
        Result.success(value))
      )
      .catchError((error) {
        if (error is DioException) {
          debugPrint('Dio error: ${error.message}');

          if (error.response?.statusCode == 422) {

            return Future<Result<PicklistDeleteResponseDto, NetworkError>>.value(
                Result.failure(NetworkError.request(error: error)));

          }
        }

        return Future<Result<PicklistDeleteResponseDto, NetworkError>>.value(
          const Result.failure(
              NetworkError.connectivity(message: 'No Internet Connection'))
        );

      });
  }

  @override
  Future setPicklistSendForPicking(String token, Map<String, dynamic> picklistData) async {
    var restClient = await _apiClient.getRestClient();

    return await restClient.setPicklistSendForPicking('Bearer $token', picklistData)
      .then((value) => Future<Result<PicklistSendForPickingResponseDto, NetworkError>>.value(
        Result.success(value))
      )
      .catchError((error) {
        if (error is DioException) {
          debugPrint('Dio error: ${error.message}');

          if (error.response?.statusCode == 422) {

            return Future<Result<PicklistSendForPickingResponseDto, NetworkError>>.value(
                Result.failure(NetworkError.request(error: error)));

          }
        }

        return Future<Result<PicklistSendForPickingResponseDto, NetworkError>>.value(
          const Result.failure(
              NetworkError.connectivity(message: 'No Internet Connection'))
        );

      });
  }

  @override
  Future setPicklistPackAll(String token, Map<String, dynamic> picklistData) async {
    var restClient = await _apiClient.getRestClient();

    return await restClient.setPicklistPackAll('Bearer $token', picklistData)
      .then((value) => Future<Result<PicklistPackAllResponseDto, NetworkError>>.value(
        Result.success(value))
      )
      .catchError((error) {
        if (error is DioException) {
          debugPrint('Dio error: ${error.message}');

          if (error.response?.statusCode == 422) {

            return Future<Result<PicklistPackAllResponseDto, NetworkError>>.value(
                Result.failure(NetworkError.request(error: error)));

          }
        }

        return Future<Result<PicklistPackAllResponseDto, NetworkError>>.value(
          const Result.failure(
              NetworkError.connectivity(message: 'No Internet Connection'))
        );

      });
  }
}