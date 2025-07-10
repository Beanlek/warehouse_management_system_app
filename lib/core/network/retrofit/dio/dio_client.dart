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
  }
}
