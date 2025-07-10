import 'package:injectable/injectable.dart';

import '../../../config/globals.dart';
import '../../../injection.dart';
import '../../services/storage_service.dart';
import 'dio/dio_client.dart';
import 'rest_client.dart';

@lazySingleton
class ApiClient {
  final DioClient _dioClient;
  RestClient? _restClientInstance;

  ApiClient(this._dioClient);

  Future<RestClient> getRestClient() async {
    _createRestClient();
    final String url = await getIt<StorageService>().retrieve(StorageService.keyBaseUrl) ?? Globals.debugURL;
    if (_dioClient.dio.options.baseUrl != url) updateUrl(url);
    print('Header : ${_dioClient.dio.options.headers}');  
    return _restClientInstance!;
  }

  void reset() {
    _restClientInstance = null;
  }

  void _createRestClient() {
    _restClientInstance ??= RestClient(_dioClient.dio);
  }

  void updateUrl(String newUrl) {
    _dioClient.dio.options.baseUrl = newUrl;
    _restClientInstance = RestClient(_dioClient.dio, baseUrl: newUrl);
  }
}
