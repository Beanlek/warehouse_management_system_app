import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:warehouse/config/globals.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_delete_response_dto.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_details_response_dto.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_pack_all_response_dto.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_response_dto.dart';
import 'package:warehouse/data/models/responses/picklist/picklist_send_for_picking_response_dto.dart';
import 'package:warehouse/data/models/responses/sites/site_list_response_dto.dart';
import 'package:warehouse/data/models/responses/warehouse/inventory_list_response_dto.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: Globals.debugURL)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/api/inventory/list/{site_id}')
  Future<InventoryListResponseDto> getWarehouseInventory(
    @Header('Authorization') String token,
    @Path('site_id') String siteId,
    @Query('active') String active,
  );

  @GET('/api/dataLookup/sites/list')
  Future<SiteListResponseDto> getSiteList(
    @Header('Authorization') String token,
  );

  @GET('/api/picklist/android/van_allotment/list')
  Future<PicklistResponseDto> getPicklist(
    @Header('Authorization') String token,
    @Query('picklist_id') String picklistId,
    @Query('status') String status,
    @Query('page') int page,
    @Query('limit_rows') int limitRows,
  );

  @GET('/api/picklist/android/van_allotment/o/{picklist_id}')
  Future<PicklistDetailsResponseDto> getPicklistDetails(
    @Header('Authorization') String token,
    @Path('picklist_id') String picklistId,
  );

  @POST('/api/picklist/android/delete')
  Future<PicklistDeleteResponseDto> deletePicklist(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> picklistData
  );

  @POST('/api/picklist/android/sendForPicking')
  Future<PicklistSendForPickingResponseDto> setPicklistSendForPicking(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> picklistData
  );
  
  @POST('/api/picklist/android/packAll')
  Future<PicklistPackAllResponseDto> setPicklistPackAll(
    @Header('Authorization') String token,
    @Body() Map<String, dynamic> picklistData
  );
}
