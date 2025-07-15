import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:warehouse/config/globals.dart';
import 'package:warehouse/core/freezed/api_response.dart';
import 'package:warehouse/core/freezed/api_response_for_listing.dart';
import 'package:warehouse/data/models/responses/sites/site_list_response_dto.dart';
import 'package:warehouse/data/models/responses/warehouse/inventory_list_response_dto.dart';
import 'package:warehouse/data/models/sites/site_dto.dart';
import 'package:warehouse/data/models/warehouse/warehouse_inventory_dto.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: Globals.debugURL)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/api/inventory/list/{site_id}')
  Future<InventoryListResponseDto> getWarehouseInventory(
    @Header('Authorization') String token,
    @Path('site_id') String siteId,
    @Query('active') bool active,
  );

  @GET('/api/dataLookup/sites/list')
  Future<SiteListResponseDto> getSiteList(
    @Header('Authorization') String token,
  );
}
