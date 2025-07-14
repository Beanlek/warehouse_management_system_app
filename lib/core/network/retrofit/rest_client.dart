import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:warehouse/config/globals.dart';
import 'package:warehouse/core/freezed/api_response.dart';
import 'package:warehouse/core/freezed/api_response_for_listing.dart';
import 'package:warehouse/data/models/responses/site_list_response_dto.dart';
import 'package:warehouse/data/models/sites/site_dto.dart';
import 'package:warehouse/data/models/warehouse/warehouse_inventory_dto.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: Globals.debugURL)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/inventory/list/{site_id}?active=true')
  Future <ApiResponseForListing<WarehouseInventoryDto>> getWarehouseInventory(
    @Header('Authorization') String token,
    @Path('site_id') String siteId,
  );

  @GET('/api/dataLookup/sites/list')
  Future<SiteListResponseDto> getSiteList(
    @Header('Authorization') String token,
  );
}
