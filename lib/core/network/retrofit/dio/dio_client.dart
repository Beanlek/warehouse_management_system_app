import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class DioClient {
  var dio = Dio();

  DioClient() {
    var options = BaseOptions(
        connectTimeout: Duration(milliseconds: 30000),
        receiveTimeout: Duration(milliseconds: 30000),
        sendTimeout: Duration(milliseconds: 30000),
        validateStatus: (statusCode) => (statusCode! >= HttpStatus.ok && statusCode <= HttpStatus.multipleChoices));
    dio = Dio(options);

    dio.interceptors.add(LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
    logPrint: (obj) => log(obj.toString()),
  ));
  }
}