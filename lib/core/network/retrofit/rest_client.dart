import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:warehouse/config/globals.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: Globals.debugURL)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  // @POST('/api/team/auth/login') //Example API endppoint
  // Future<LoginResponse> login(@Body() Map<String, dynamic> loginData);
}
