
import 'package:warehouse/core/freezed/network_error.dart';
import 'package:warehouse/core/freezed/result.dart';
import 'package:warehouse/core/shared/app_error.dart';

Future<Result<ResultType, AppError>> networkOutBoundItem<ResultType, RequestResponseDtoType>(
    {required bool Function() isOnline,
    required Future<Result<RequestResponseDtoType, AppError>> Function() apiRequest,
    required bool Function(RequestResponseDtoType? apiResult) isRequestSuccessful,
    required Result<ResultType, AppError> Function(RequestResponseDtoType? apiResult) getSuccessState,
    required Result<ResultType, AppError> Function(AppError errorApiResult) getErrorState}) async {
  if (isOnline()) {
    var apiResult = await apiRequest();
    return apiResult.when(success: (RequestResponseDtoType data) {
      if (isRequestSuccessful(data)) {
        return getSuccessState(data);
      } else {
        return getErrorState(const NetworkError.api());
      }
    }, failure: (AppError error) {
      return getErrorState(error);
    });
  } else {
    return getSuccessState(null);
  }
}

Future<Result<ResultType, AppError>> networkInBoundItem<ResultType, RequestResponseDtoType>(
    {required Future<Result<RequestResponseDtoType, AppError>> Function() apiRequest,
    required Function(RequestResponseDtoType requestResponse) saveToDb,
    required Result<ResultType, AppError> Function(RequestResponseDtoType apiResult) getSuccessState,
    required Result<ResultType, AppError> Function(AppError errorApiResult) getErrorState}) async {
  var apiResult = await apiRequest();
  return apiResult.when(success: (RequestResponseDtoType data) {
    saveToDb(data);
    return getSuccessState(data);
  }, failure: (AppError error) {
    return getErrorState(error);
  });
}

Future<Result<ResultType, AppError>> genericNetworkItem<ResultType, RequestResponseDtoType, RequestResponseType>(
    {required Future<Result<RequestResponseType, AppError>> Function() apiRequest,
    required AppError? Function(RequestResponseType requestResponse) extractErrors,
    required RequestResponseDtoType? Function(RequestResponseType requestResponse) extractDto,
    required Function(RequestResponseDtoType extractedDto) saveToDb,
    required Result<ResultType, AppError> Function(RequestResponseDtoType extractedDto) getSuccessState,
    required Result<ResultType, AppError> Function(AppError errorApiResult) getErrorState}) async {
  var apiResult = await apiRequest();
  return apiResult.when(success: (RequestResponseType data) {
    var errors = extractErrors(data);
    if (errors != null) {
      return getErrorState(errors);
    }
    RequestResponseDtoType? extractedDto = extractDto(data);
    if (extractedDto == null) {
      return getErrorState(const NetworkError.type(error: 'Extracted object from API was null'));
    }
    saveToDb(extractedDto);
    return getSuccessState(extractedDto);
  }, failure: (AppError error) {
    return getErrorState(error);
  });
}
