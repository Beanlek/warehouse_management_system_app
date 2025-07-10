import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/core/freezed/api_response.dart';
import 'package:warehouse/core/freezed/api_response_for_listing.dart';
import 'package:warehouse/core/freezed/network_error.dart';
import 'package:warehouse/core/freezed/result.dart';
import 'package:warehouse/core/network/network_connectivity.dart';
import 'package:warehouse/core/shared/app_error.dart';

import '../../../injection.dart';

class RestApiExecutor {
  static Completer<void>? _forbiddenErrorCompleter;

  static Future<Result<List<DTOModel>, AppError>> executeForList<DTOModel>(
      {required Future<ApiResponseForListing<DTOModel>> Function()
          requestCall}) async {
    debugPrint('$requestCall');
    // Check Network Connectivity
    if (await NetworkConnectivity.status) {
      try {
        var response = await requestCall();
        if (response.error != null) {
          debugPrint(
              '$requestCall => ${NetworkError.type(error: response.error)}');
          return Result.failure(NetworkError.api(message: response.error));
        }
        if (response.data?.rows == null) {
          // TODO create custom error for mapping
          debugPrint(
              '$requestCall => ${const NetworkError.type(error: "List is empty")}');
          return const Result.failure(
              NetworkError.type(error: 'List is empty'));
        }
        return Result.success(response.data!.rows!);
      } on DioException catch (diorError) {
        debugPrint('$requestCall => ${NetworkError.request(error: diorError)}');
        return Result.failure(NetworkError.request(error: diorError));
      } on TypeError catch (e) {
        // type error
        debugPrint('$requestCall => ${NetworkError.type(error: e.toString())}');
        return Result.failure(NetworkError.type(error: e.toString()));
      }
    } else {
      // No Internet Connection
      debugPrint(
          '${const NetworkError.connectivity(message: 'No Internet Connection')}');
      return const Result.failure(
          NetworkError.connectivity(message: 'No Internet Connection'));
    }
  }

  static Future<Result<DTOModel, AppError>> execute<DTOModel>(
      {required Future<ApiResponse<DTOModel>> Function() requestCall}) async {
    debugPrint('$requestCall');
    // Check Network Connectivity
    if (await NetworkConnectivity.status) {
      try {
        var response = await requestCall();
        if (response.error != null) {
          debugPrint(
              '$requestCall => ${NetworkError.type(error: response.error)}');
          return Result.failure(NetworkError.api(message: response.error));
        }
        if (response.data == null) {
          // TODO create custom error for mapping
          debugPrint(
              '$requestCall => ${const NetworkError.type(error: "List is empty")}');
          return const Result.failure(
              NetworkError.type(error: 'List is empty'));
        }
        return Result.success(response.data as DTOModel);
      } on DioException catch (diorError) {
        // network error
        debugPrint('$requestCall => ${NetworkError.request(error: diorError)}');
        return Result.failure(NetworkError.request(error: diorError));
      } on TypeError catch (e) {
        // type error
        debugPrint('$requestCall => ${NetworkError.type(error: e.toString())}');
        return Result.failure(NetworkError.type(error: e.toString()));
      }
    } else {
      // No Internet Connection
      debugPrint(
          '${const NetworkError.connectivity(message: 'No Internet Connection')}');
      return const Result.failure(
          NetworkError.connectivity(message: 'No Internet Connection'));
    }
  }

  ///
  /// Used for Apis with custom callback
  /// <b>NOTE</b> you must handle errors from API and null cases manually.
  static Future<Result<DTOModel, AppError>> executeGeneric<DTOModel>(
      {required Future<DTOModel> Function() requestCall}) async {
    debugPrint('$requestCall');
    // Check Network Connectivity
    if (await NetworkConnectivity.status) {
      try {
        var response = await requestCall();
        debugPrint('API Response: ${jsonEncode(response)}');
        return Result.success(response);
      } on DioException catch (diorError) {
        debugPrint('$requestCall => ${NetworkError.request(error: diorError)}');
        return Result.failure(NetworkError.request(error: diorError));
      } on TypeError catch (e) {
        // type error
        debugPrint('$requestCall => ${NetworkError.type(error: e.toString())}');
        return Result.failure(NetworkError.type(error: e.toString()));
      }
    } else {
      // No Internet Connection
      debugPrint(
          '${const NetworkError.connectivity(message: 'No Internet Connection')}');
      return const Result.failure(
          NetworkError.connectivity(message: 'No Internet Connection'));
    }
  }
}
