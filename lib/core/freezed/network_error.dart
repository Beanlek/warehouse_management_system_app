import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:warehouse/core/shared/app_error.dart';

part 'network_error.freezed.dart';

@freezed
class NetworkError with _$NetworkError implements AppError {
  const NetworkError._() : super();

  const factory NetworkError.request({required DioException error}) =
      _ResponseError;

  const factory NetworkError.type({String? error}) = _DecodingError;

  const factory NetworkError.connectivity({String? message}) = _Connectivity;

  const factory NetworkError.api({String? message}) = _ApiError;

  @override
  String? get localizedErrorMessage {
    return when<String?>(
        type: (error) => error,
        connectivity: (message) => message,
        request: (DioException error) {
          switch (error.type) {
            case DioExceptionType.badResponse:
              return error.response?.data['errMsg'];
            case DioExceptionType.unknown:
              var otherError = error.error;

              if (otherError != null) {
                if (otherError is SocketException) {
                  return otherError.message;
                } else {
                  return otherError.toString();
                }
              }

              return error.toString();

            default:
              return error.message;
          }
        },
        api: (message) => message);
  }
}
